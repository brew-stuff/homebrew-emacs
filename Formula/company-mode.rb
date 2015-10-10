require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CompanyMode < EmacsFormula
  desc "Modular in-buffer completion framework for Emacs"
  homepage "http://company-mode.github.io"
  url "https://github.com/company-mode/company-mode/archive/0.8.12.tar.gz"
  sha256 "ff7f70a13e353181526f8a11145f543955fb3f76c6772cf6d79912782a5e95ef"
  head "https://github.com/company-mode/company-mode.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  option "with-emoji", "Install company-emoji"
  option "with-web", "Install company-web"

  if build.with? "web"
    depends_on "homebrew/emacs/dash-emacs"
    depends_on "homebrew/emacs/web-completion-data"
  end

  resource "emoji" do
    url "https://github.com/dunn/company-emoji/archive/v2.1.0.tar.gz"
    sha256 "3b626cc62ed12d8a6024faf9b80a750bd9a7daed3becd53aacae63d96dc962ea"
  end

  resource "web" do
    url "https://github.com/osv/company-web/archive/v0.9.tar.gz"
    sha256 "c5e26ae5eb9f7c57684b24ad9a960fa86df5ab2e2dac14b7b1068f3853a98622"
  end

  def install
    if build.with? "emoji"
      resource("emoji").stage do
        byte_compile "company-emoji.el"
        (share/"emacs/site-lisp/company/emoji").install Dir["*.el"],
                                                        Dir["*.elc"]
      end
    end

    if build.with? "web"
      resource("web").stage do
        byte_compile Dir["*.el"]
        (share/"emacs/site-lisp/company/web").install Dir["*.el"],
                                                      Dir["*.elc"]
      end
    end

    system "make", "test-batch"
    system "make", "compile"
    (share/"emacs/site-lisp/company").install Dir["company*.el"],
                                              Dir["company*.elc"]
    doc.install "README.md"
  end

  def caveats
    s = <<-EOS.undent
      Add the following to your init file:

      (require 'company)
      (add-hook 'after-init-hook 'global-company-mode)
    EOS
    if build.with? "emoji"
      s += <<-EOS.undent

      (require 'company-emoji)
      (add-hook 'markdown-mode-hook 'company-mode)
      (add-hook 'company-mode-hook 'company-emoji-init)
    EOS
    end
    if build.with? "web"
      s += <<-EOS.undent

      (require 'company-web-html)
    EOS
    end
    s
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/company")
      (load "company")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CompanyMode < EmacsFormula
  desc "Modular in-buffer completion framework for Emacs"
  homepage "http://company-mode.github.io"
  url "https://github.com/company-mode/company-mode/archive/0.8.12.tar.gz"
  sha256 "ff7f70a13e353181526f8a11145f543955fb3f76c6772cf6d79912782a5e95ef"
  head "https://github.com/company-mode/company-mode.git"

  depends_on :emacs => "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < 24.3

  def install
    system "make", "test-batch"
    system "make", "compile"

    (share/"emacs/site-lisp/company").install Dir["company*.el"],
                                              Dir["company*.elc"]
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'company)
    (add-hook 'after-init-hook 'global-company-mode)
  EOS
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

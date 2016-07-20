require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CompanyMode < EmacsFormula
  desc "Modular in-buffer completion framework for Emacs"
  homepage "https://company-mode.github.io"
  url "https://github.com/company-mode/company-mode/archive/0.9.0.tar.gz"
  sha256 "a15621088d8ce2d8ea4b9df3fac836dd337509fbf627937cb1b0ef4e08ca2462"
  head "https://github.com/company-mode/company-mode.git"

  option "with-emoji", "Install emoji backend"
  option "with-php", "Install PHP backend"
  option "with-statistics", "Include statistical ranking minor mode"
  option "with-web", "Install web templating backend"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  if build.with? "web"
    depends_on "homebrew/emacs/dash-emacs"
    depends_on "homebrew/emacs/web-completion-data"
  end

  if build.with? "php"
    depends_on "homebrew/emacs/f-emacs"
    depends_on "homebrew/emacs/popup"
    depends_on "homebrew/emacs/s-emacs"
    depends_on "homebrew/emacs/xcscope"
    depends_on "homebrew/emacs/yasnippet"
  end

  resource "emoji" do
    url "https://github.com/dunn/company-emoji/archive/2.3.0.tar.gz"
    sha256 "51f5c3c43ab6fcb79ea88115b0e773269cc02d56a8dbaec1f83f7fbe3e5f34f8"
  end

  resource "php" do
    url "https://github.com/xcwen/ac-php/archive/1.7.4.tar.gz"
    sha256 "7e409509b59fd665a235fbb38f621099015b739943c7d82a3131762da3246de3"
  end

  resource "statistics" do
    url "https://github.com/company-mode/company-statistics/archive/0.2.2.tar.gz"
    sha256 "31c7f68324f492cbe658f0733841e4de64149e86f821c878c390edb0e840e420"
  end

  resource "web" do
    url "https://github.com/osv/company-web/archive/v0.9.tar.gz"
    sha256 "c5e26ae5eb9f7c57684b24ad9a960fa86df5ab2e2dac14b7b1068f3853a98622"
  end

  def install
    if build.with? "emoji"
      resource("emoji").stage do
        byte_compile "company-emoji.el"
        (elisp/"emoji").install Dir["*.el"], Dir["*.elc"]
      end
    end

    if build.with? "php"
      resource("php").stage do
        byte_compile (Dir["*.el"] - ["ac-php.el"])
        (elisp/"php").install [(Dir["*.el"] - ["ac-php.el"]),
                               Dir["*.elc"], Dir["*.json"], "phpctags"].flatten
      end
    end

    if build.with? "statistics"
      resource("statistics").stage do
        byte_compile "company-statistics.el"
        (elisp/"statistics").install Dir["*.el"], Dir["*.elc"]
      end
    end

    if build.with? "web"
      resource("web").stage do
        byte_compile Dir["*.el"]
        (elisp/"web").install Dir["*.el"], Dir["*.elc"]
      end
    end

    system "make", "test-batch"
    system "make", "compile"
    elisp.install Dir["company*.el"], Dir["company*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "company")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

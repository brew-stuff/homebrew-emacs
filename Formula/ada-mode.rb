require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AdaMode < EmacsFormula
  desc "Emacs major mode for editing Ada sources"
  homepage "http://stephe-leake.org/emacs/ada-mode/emacs-ada-mode.html"
  url "http://stephe-leake.org/emacs/ada-mode/org.emacs.ada-mode-5.1.8.tar.gz"
  sha256 "da22247244cafe9395189fcca13667448fbc6a0fd52fb0cbcd8c3b0545aaf092"

  option "without-reference", "Build without the reference manual"

  depends_on :emacs => "24.2"

  resource "reference" do
    url "http://stephe-leake.org/ada/arm_info-2012.2.tar.gz"
    sha256 "e861098b37faf38289b0ada9543bb2f846285080512d86e052a4154d0a800e61"
  end

  resource "mode-keys" do
    url "http://stephe-leake.org/emacs/ada-mode/ada-mode-keys.el"
    sha256 "51fcdc58780ed2f63a6ccd956c3a349d34da93e4271986b7c3cc2e42e11dd6bd"
  end

  def install
    # there's `make byte-compile` but it uses package.el
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/ada-mode").install Dir["*.el"],
                                               Dir["*.elc"]
    info.install Dir["*.info"]
    if build.with? "reference"
      resource("reference").stage { info.install Dir["*"] }
    end

    resource("mode-keys").stage do
      byte_compile "ada-mode-keys.el"
      (prefix/"contrib").install "ada-mode-keys.el",
                                 "ada-mode-keys.elc"
    end
  end

  def caveats; <<-EOS.undent
    Example settings have been installed in #{prefix}/contrib

    Add the following to your init file:

    (require 'ada-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/ada-mode")
      (load "ada-mode")
      (print (ada-mode-version))
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

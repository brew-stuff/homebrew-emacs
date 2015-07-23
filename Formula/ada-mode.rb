require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AdaMode < EmacsFormula
  desc "Emacs major mode for editing Ada sources"
  homepage "http://stephe-leake.org/emacs/ada-mode/emacs-ada-mode.html"
  url "http://stephe-leake.org/emacs/ada-mode/org.emacs.ada-mode-5.1.8.tar.gz"
  sha256 "361b5e4f3bd8cb48a236245ce65093c361175e4ae782d0233555bd9bd294aa91"

  option "without-reference", "Build without the reference manual"

  depends_on :emacs => "24.2"

  resource "reference" do
    url "http://stephe-leake.org/ada/arm_info-2012.2.tar.gz"
    sha256 "4e734e37b82a5db34656c6cff9bfee0b11f9ebbcac1cc6716d80541a25359970"
  end

  resource "mode-keys" do
    url "http://stephe-leake.org/emacs/ada-mode/ada-mode-keys.el"
    sha256 "e24580f931f1f989413091933fe653ff009739fdcf22573d04d7670093e9ceb9"
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
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "ada-mode")
      (print (ada-mode-version))
    EOS
    assert_match version.to_s, shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AdaMode < EmacsFormula
  desc "Emacs major mode for editing Ada sources"
  homepage "http://stephe-leake.org/emacs/ada-mode/emacs-ada-mode.html"
  url "https://elpa.gnu.org/packages/ada-mode-5.2.0.tar"
  sha256 "19dfd93c3c466cf4a246fae3c0123051490f6640bd3cefa791e54f5f17498ec8"

  option "without-reference", "Build without the reference manual"

  depends_on :emacs => "24.2"
  depends_on "homebrew/emacs/wisi-emacs"

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
    elisp.install Dir["*.el"], Dir["*.elc"]

    info.install Dir["*.info"]
    if build.with? "reference"
      resource("reference").stage { info.install Dir["*"] }
    end

    resource("mode-keys").stage do
      (prefix/"contrib").install "ada-mode-keys.el"
    end
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["wisi-emacs"].opt_elisp}")
      (load "ada-mode")
      (print (ada-mode-version))
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

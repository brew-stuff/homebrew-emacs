require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class MochaEmacs < EmacsFormula
  desc "Minor mode for running Mocha tests"
  homepage "https://github.com/scottaj/mocha.el"
  url "https://github.com/scottaj/mocha.el/archive/v1.1.tar.gz"
  sha256 "3fc74e93cbd52bd8b866d415dbdb3ad231d969941780d09afacee595cb15840d"

  head do
    url "https://github.com/scottaj/mocha.el.git"
    depends_on "dunn/emacs/f-emacs"
    depends_on "dunn/emacs/s-emacs"
  end

  depends_on EmacsRequirement
  depends_on "dunn/emacs/js2-mode"

  def install
    byte_compile "mocha.el"
    elisp.install "mocha.el", "mocha.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/js2-mode"].opt_elisp}")
      (load "mocha")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

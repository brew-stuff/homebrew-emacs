require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ContextColoring < EmacsFormula
  desc "Emacs mode to color JS and Elisp code by scope"
  homepage "https://github.com/jacksonrayhamilton/context-coloring"
  url "https://github.com/jacksonrayhamilton/context-coloring/archive/v7.2.0.tar.gz"
  sha256 "e16a890a070addfc857e5d6ea3b60cb9bd7d447cb123e82a34126f948168beec"
  head "https://github.com/jacksonrayhamilton/context-coloring.git"

  depends_on :emacs => "24.3"
  depends_on "cask"
  depends_on "homebrew/emacs/js2-mode"

  def install
    system "make", "test", "CASK=#{Formula["cask"].bin}/cask"
    system "make", "compile", "CASK=#{Formula["cask"].bin}/cask"
    elisp.install "context-coloring.el", "context-coloring.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["js2-mode"].opt_elisp}")
      (load "context-coloring")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

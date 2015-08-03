require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ContextColoring < EmacsFormula
  desc "Emacs mode to highlight JS and Elisp code by scope"
  homepage "https://github.com/jacksonrayhamilton/context-coloring"
  url "https://github.com/jacksonrayhamilton/context-coloring/archive/v7.0.0.tar.gz"
  sha256 "d321bff4dd6a9be795ca701ee3adab88258b62f6d4f7d5eef3167c818aca1c84"
  head "https://github.com/jacksonrayhamilton/context-coloring.git"

  depends_on :emacs => "24.3"
  depends_on "cask"
  depends_on "homebrew/emacs/js2-mode"

  def install
    system "make", "test", "CASK=#{Formula["cask"].bin}/cask"
    system "make", "compile", "CASK=#{Formula["cask"].bin}/cask"
    (share/"emacs/site-lisp/context-coloring").install "context-coloring.el",
                                                       "context-coloring.elc"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'context-coloring)
    (add-hook 'emacs-lisp-mode-hook #'context-coloring-mode)
    (add-hook 'minibuffer-setup-hook #'context-coloring-mode)

    ;; JavaScript highlighting requires js2-mode
    (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
    (add-hook 'js2-mode-hook #'context-coloring-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/context-coloring")
      (add-to-list 'load-path "#{Formula["js2-mode"].share}/emacs/site-lisp/js2-mode")
      (load "context-coloring")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

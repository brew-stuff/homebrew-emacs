require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WhichKey < EmacsFormula
  desc "Emacs package for displaying available keybindings"
  homepage "https://github.com/justbur/emacs-which-key"
  url "https://github.com/justbur/emacs-which-key/archive/v0.6.2.tar.gz"
  sha256 "dd6800283b5d53a9a49bd2f6acceb5b3bd88a7c31902a6b2dc948aa917bf6163"
  head "https://github.com/justbur/emacs-which-key.git"

  depends_on :emacs => "24.3"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/s"

  def install
    byte_compile "which-key.el"
    (share/"emacs/site-lisp/which-key").install "which-key.el",
                                                "which-key.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/which-key")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/s"].opt_share}/emacs/site-lisp/s")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_share}/emacs/site-lisp/dash")
      (load "which-key")
      (which-key-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

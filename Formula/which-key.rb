require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WhichKey < EmacsFormula
  desc "Emacs package for displaying available keybindings"
  homepage "https://github.com/justbur/emacs-which-key"
  url "https://github.com/justbur/emacs-which-key/archive/v0.5.1.tar.gz"
  sha256 "c02b4c38c43c59b7db6fb884cd9cd43205a4146c7ab7e2cda3034cf606b1d019"
  head "https://github.com/justbur/emacs-which-key.git"

  depends_on :emacs => "24.3"
  depends_on "homebrew/emacs/dash"
  depends_on "homebrew/emacs/s"

  def install
    byte_compile "which-key.el"
    (share/"emacs/site-lisp/which-key").install "which-key.el",
                                                "which-key.elc"
    doc.install "README.org"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'which-key)
    (which-key-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/which-key")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/s"].share}/emacs/site-lisp/s")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash"].share}/emacs/site-lisp/dash")
      (load "which-key")
      (which-key-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

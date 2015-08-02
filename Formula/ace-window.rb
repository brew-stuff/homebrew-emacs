require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AceWindow < EmacsFormula
  desc "Faster window switching in Emacs"
  homepage "https://github.com/abo-abo/ace-window"
  url "https://github.com/abo-abo/ace-window/archive/0.9.0.tar.gz"
  sha256 "f616898826457431a235294165866875a72a2a3514376adafa84d656a87b5adc"
  head "https://github.com/abo-abo/ace-window.git"

  depends_on :emacs
  depends_on "dunn/emacs/avy"

  def install
    # there's a Makefile but it uses cask to do the same thing
    byte_compile "ace-window.el"
    (share/"emacs/site-lisp/ace-window").install "ace-window.el",
                                                 "ace-window.elc"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'ace-window)
    (global-set-key (kbd "M-p") 'ace-window)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/ace-window")
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/avy")
      (load "ace-window")
      (aw-window-list)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

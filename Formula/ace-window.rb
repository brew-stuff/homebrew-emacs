require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AceWindow < EmacsFormula
  desc "Faster window switching in Emacs"
  homepage "https://github.com/abo-abo/ace-window"
  url "https://github.com/abo-abo/ace-window/archive/0.9.0.tar.gz"
  sha256 "f616898826457431a235294165866875a72a2a3514376adafa84d656a87b5adc"
  head "https://github.com/abo-abo/ace-window.git"

  depends_on :emacs
  depends_on "homebrew/emacs/avy"

  def install
    byte_compile "ace-window.el"
    elisp.install "ace-window.el", "ace-window.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/avy"].opt_elisp}")
      (load "ace-window")
      (aw-window-list)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class XclipMode < EmacsFormula
  desc "Emacs mode to copy and paste using xclip"
  homepage "http://elpa.gnu.org/packages/xclip.html"
  url "http://elpa.gnu.org/packages/xclip-1.3.el"
  sha256 "8724069facb86870058c1a6d2e321dfb2e6df3252bb1a29ed408157435c998fe"
  revision 1

  depends_on :emacs
  depends_on "xclip"

  def install
    mv "xclip-#{version}.el", "xclip.el"
    byte_compile "xclip.el"
    elisp.install "xclip.el", "xclip.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'xclip)
    (xclip-mode 1)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "xclip")
      (turn-on-xclip)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class XclipMode < EmacsFormula
  desc "Emacs mode to copy and paste using xclip"
  homepage "https://elpa.gnu.org/packages/xclip.html"
  url "https://elpa.gnu.org/packages/xclip-1.4.el"
  sha256 "d7d09f5f3461e70a3589124be4955f1e858e0f83220987359320c8cf413a3c8b"

  depends_on :emacs
  depends_on "xclip"

  def install
    mv "xclip-#{version}.el", "xclip.el"
    byte_compile "xclip.el"
    elisp.install "xclip.el", "xclip.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "xclip")
      (xclip-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

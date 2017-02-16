require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class NhexlMode < EmacsFormula
  desc "Emacs minor mode for editing hex dumps"
  homepage "https://elpa.gnu.org/packages/nhexl-mode.html"
  url "https://elpa.gnu.org/packages/nhexl-mode-0.2.el"
  sha256 "a097eebd37ec42776595f54e54987829f3aef653457a33c25822f2d6fbbc3f63"

  depends_on :emacs
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    mv "nhexl-mode-#{version}.el", "nhexl-mode.el"
    byte_compile "nhexl-mode.el"
    elisp.install "nhexl-mode.el", "nhexl-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "nhexl-mode")
      (nhexl-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

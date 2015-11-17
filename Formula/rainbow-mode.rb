require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class RainbowMode < EmacsFormula
  desc "Minor mode for highlighting color-strings"
  homepage "http://elpa.gnu.org/packages/rainbow-mode.html"
  url "http://elpa.gnu.org/packages/rainbow-mode-0.12.el"
  sha256 "04b020c5a2da88165a25ffb574e80a66ca678434c526d9378998f0ed8ec64781"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/rainbow-mode/rainbow-mode.el"

  depends_on :emacs

  def install
    mv "rainbow-mode-#{version}.el", "rainbow-mode.el" if build.stable?

    byte_compile "rainbow-mode.el"
    elisp.install "rainbow-mode.el", "rainbow-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "rainbow-mode")
      (rainbow-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

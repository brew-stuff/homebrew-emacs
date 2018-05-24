require File.expand_path("../Homebrew/emacs_formula", __dir__)

class RainbowMode < EmacsFormula
  desc "Minor mode for highlighting color-strings"
  homepage "https://elpa.gnu.org/packages/rainbow-mode.html"
  url "https://elpa.gnu.org/packages/rainbow-mode-1.0.1.el"
  sha256 "4e33e4d749991c59c3930f08cf1a00dc8369d581750b7fe475b90cd31551ef32"

  depends_on EmacsRequirement => "24.1"

  def install
    mv "rainbow-mode-#{version}.el", "rainbow-mode.el" if build.stable?

    byte_compile "rainbow-mode.el"
    elisp.install "rainbow-mode.el", "rainbow-mode.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "rainbow-mode")
      (rainbow-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

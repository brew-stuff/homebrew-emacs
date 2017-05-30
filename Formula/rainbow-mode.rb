require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class RainbowMode < EmacsFormula
  desc "Minor mode for highlighting color-strings"
  homepage "https://elpa.gnu.org/packages/rainbow-mode.html"
  url "https://elpa.gnu.org/packages/rainbow-mode-0.13.el"
  sha256 "b4b5f6479d8e2a910cc8718569a37bc7c0ccdf13206b2e23be183f6c7a556ab4"

  depends_on :emacs => "24.1"

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

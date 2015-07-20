class RainbowMode < Formula
  desc "Minor mode for highlighting color-strings"
  homepage "http://elpa.gnu.org/packages/rainbow-mode.html"
  url "http://elpa.gnu.org/packages/rainbow-mode-0.11.el"
  sha256 "honk"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/rainbow-mode/rainbow-mode.el"

  def install
    version_string = build.stable? ? "-#{version}" : ""
    (share/"emacs/site-lisp/rainbow-mode").install "rainbow-mode#{version_string}.el" => "rainbow-mode.el"
  end

  def caveats; <<-EOS.undent
    Add hooks to activate rainbow-mode where desired, like so:

      (add-hook 'scss-mode-hook 'scss-rainbow-hook)
      (defun scss-rainbow-hook ()
        "Colorize color strings."
        (rainbow-mode 1))
    EOS
  end
end

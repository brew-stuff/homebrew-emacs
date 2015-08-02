require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class RainbowMode < EmacsFormula
  desc "Minor mode for highlighting color-strings"
  homepage "http://elpa.gnu.org/packages/rainbow-mode.html"
  url "http://elpa.gnu.org/packages/rainbow-mode-0.11.el"
  sha256 "72ed06fb4f2f3ab1d5e2a9aac10864bce1d45f1923e52ee9a8e6d8f2930e16a5"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/rainbow-mode/rainbow-mode.el"

  depends_on :emacs

  def install
    mv "rainbow-mode-#{version}.el", "rainbow-mode.el" if build.stable?

    byte_compile "rainbow-mode.el"
    (share/"emacs/site-lisp/rainbow-mode").install "rainbow-mode.el",
                                                   "rainbow-mode.elc"
  end

  def caveats; <<-EOS.undent
    Add hooks to activate rainbow-mode where desired, like so:

    (require 'rainbow-mode)
    (add-hook 'scss-mode-hook 'scss-rainbow-hook)
    (defun scss-rainbow-hook ()
      "Colorize color strings."
      (rainbow-mode 1))
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp")
      (load "rainbow-mode")
      (rainbow-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

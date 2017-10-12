require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AhungryEmacs < EmacsFormula
  desc "Bright and bold color theme for Emacs"
  homepage "https://github.com/ahungry/color-theme-ahungry"
  url "https://elpa.gnu.org/packages/ahungry-theme-1.6.0.tar"
  sha256 "5ff3e769788117c0b88102ead89e0465f7facf48cb2081aaafc7be51ce3b1dac"
  head "https://github.com/ahungry/color-theme-ahungry.git"

  depends_on :emacs => "24.1"

  def install
    byte_compile "ahungry-theme.el", "color-theme-ahungry.el"
    elisp.install "ahungry-theme.el", "color-theme-ahungry.el",
                  "ahungry-theme.elc", "color-theme-ahungry.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'custom-theme-load-path "#{elisp}")
      (load-theme 'ahungry t)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

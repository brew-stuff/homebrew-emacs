require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AhungryEmacs < EmacsFormula
  desc "Bright and bold color theme for Emacs"
  homepage "https://github.com/ahungry/color-theme-ahungry"
  url "https://elpa.gnu.org/packages/ahungry-theme-1.7.0.tar"
  sha256 "72dc6df01926926db71e4eb2f6b6fd6b2fbc868fbf930024f37ca7c06c121f47"
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

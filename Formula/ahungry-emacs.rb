require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AhungryEmacs < EmacsFormula
  desc "Bright and bold color theme for Emacs"
  homepage "https://github.com/ahungry/color-theme-ahungry"
  url "https://elpa.gnu.org/packages/ahungry-theme-1.5.0.tar"
  sha256 "2958fc543eeb2c305cc7ccc12375614d1948253cccfcb4be539c9dc615aebf77"
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

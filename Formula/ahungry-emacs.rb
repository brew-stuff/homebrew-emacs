require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AhungryEmacs < EmacsFormula
  desc "Bright and bold color theme for Emacs"
  homepage "https://github.com/ahungry/color-theme-ahungry"
  url "http://elpa.gnu.org/packages/ahungry-theme-1.0.12.tar"
  sha256 "a8dbfd260d1f9261db61a1203564932196e9a0db0fb5ce8992fbaca066a7d528"
  head "https://github.com/ahungry/color-theme-ahungry.git"

  depends_on :emacs => "24.1"

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
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

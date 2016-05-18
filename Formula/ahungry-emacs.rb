require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AhungryEmacs < EmacsFormula
  desc "Bright and bold color theme for Emacs"
  homepage "https://github.com/ahungry/color-theme-ahungry"
  url "https://elpa.gnu.org/packages/ahungry-theme-1.2.0.tar"
  sha256 "2dbdcad31eb6a4afc70a7819e6b2599c4f245f8f7eb827c03554bfaf3b6ae913"
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

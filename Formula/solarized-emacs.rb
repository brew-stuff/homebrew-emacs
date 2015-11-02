require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SolarizedEmacs < EmacsFormula
  desc "The Solarized color scheme for Emacs"
  homepage "https://github.com/sellout/emacs-color-theme-solarized"
  head "https://github.com/sellout/emacs-color-theme-solarized.git"

  depends_on :emacs => "22.1"

  def install
    system "make", "build"
    elisp.install Dir["*.el"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'custom-theme-load-path "#{elisp}")
      (load-theme 'solarized t)
      (setq solarized-termcolors 256)
      (add-to-list 'default-frame-alist '(background-mode . dark))
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

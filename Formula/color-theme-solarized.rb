require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ColorThemeSolarized < EmacsFormula
  desc "Ethan Schoonover's Solarized color scheme for Emacs"
  homepage "https://github.com/sellout/emacs-color-theme-solarized"
  head "https://github.com/sellout/emacs-color-theme-solarized.git"

  depends_on :emacs

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/solarized").install Dir["*.el"],
                                                Dir["*.elc"]
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following lines to your init file:

    (add-to-list 'custom-theme-load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/solarized")
    (load-theme 'solarized t)
    (setq solarized-termcolors 256)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'custom-theme-load-path "#{share}/emacs/site-lisp/solarized")
      (load-theme 'solarized t)
      (setq solarized-termcolors 256)
      (add-to-list 'default-frame-alist '(background-mode . dark))
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WcheckMode < EmacsFormula
  desc "General-purpose text-checker interface for Emacs"
  homepage "https://github.com/tlikonen/wcheck-mode"
  url "https://github.com/tlikonen/wcheck-mode/archive/2014.6.21.tar.gz"
  sha256 "0fb67bc2042036e01890a0b43f9d3eca4f8522ba70dd53c0b614a3baaa1e57ed"
  head "https://github.com/tlikonen/wcheck-mode.git"

  depends_on :emacs

  def install
    system "make", "elc"
    (share/"emacs/site-lisp/wcheck-mode").install "wcheck-mode.el",
                                                  "wcheck-mode.elc"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (autoload 'wcheck-mode "wcheck-mode"
      "Toggle wcheck-mode." t)
    (autoload 'wcheck-change-language "wcheck-mode"
      "Switch wcheck-mode languages." t)
    (autoload 'wcheck-actions "wcheck-mode"
      "Open actions menu." t)
    (autoload 'wcheck-jump-forward "wcheck-mode"
      "Move point forward to next marked text area." t)
    (autoload 'wcheck-jump-backward "wcheck-mode"
      "Move point backward to previous marked text area." t)

    (global-set-key (kbd "C-c s") 'wcheck-mode)
    (global-set-key (kbd "C-c l") 'wcheck-change-language)
    (global-set-key (kbd "C-c c") 'wcheck-actions)
    (global-set-key (kbd "C-c n") 'wcheck-jump-forward)
    (global-set-key (kbd "C-c p") 'wcheck-jump-backward)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/wcheck-mode")
      (load "wcheck-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

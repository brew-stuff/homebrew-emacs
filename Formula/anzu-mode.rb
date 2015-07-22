require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AnzuMode < EmacsFormula
  desc "Emacs minor mode for numbering search results"
  homepage "https://github.com/syohex/emacs-anzu"
  url "https://github.com/syohex/emacs-anzu/archive/0.53.tar.gz"
  sha256 "1fc91eb2ab0676104ad873438b14b917a1f3742b8585930a0e8cf20042b87a48"
  head "https://github.com/syohex/emacs-anzu.git"

  depends_on :emacs => "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile "anzu.el"
    (share/"emacs/site-lisp/anzu").install "anzu.el", "anzu.elc"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'anzu)
    (global-anzu-mode +1)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "anzu")
      (anzu-mode +1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

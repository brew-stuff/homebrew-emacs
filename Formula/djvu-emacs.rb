require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DjvuEmacs < EmacsFormula
  desc "Emacs front-end for djvused"
  homepage "http://elpa.gnu.org/packages/djvu.html"
  url "http://elpa.gnu.org/packages/djvu-0.5.el"
  sha256 "52e3f98512c3b1425a1e1c7e36c6b435446b071cb21ca91c2c5fbbaa23d9fef2"

  depends_on EmacsRequirement
  depends_on "djvulibre"

  def install
    mv "djvu-#{version}.el", "djvu.el"
    byte_compile "djvu.el"
    (share/"emacs/site-lisp/djvu").install "djvu.el", "djvu.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'djvu)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/djvu")
      (load "djvu")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

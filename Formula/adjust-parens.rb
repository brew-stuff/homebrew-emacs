require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AdjustParens < EmacsFormula
  desc "Emacs minor mode for indenting Lisp and Clojure"
  homepage "http://elpa.gnu.org/packages/adjust-parens.html"
  url "http://elpa.gnu.org/packages/adjust-parens-3.0.tar"
  sha256 "ef3febb45ed9a4291bec226ce7d7d641b75a7c3f2e197382894763efdacbf599"

  depends_on EmacsRequirement

  def install
    system "make"
    (share/"emacs/site-lisp/adjust-parens").install Dir["*.el"],
                                                    Dir["*.elc"]
  end

  def caveats; <<~EOS
    Add the following to your init file:

    (require 'adjust-parens)
    (add-hook 'emacs-lisp-mode-hook #'adjust-parens-mode)
    (add-hook 'clojure-mode-hook #'adjust-parens-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/adjust-parens")
      (load "adjust-parens")
      (adjust-parens-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class EldocEval < EmacsFormula
  desc "Emacs package for eldoc support when the minibuffer is in use"
  homepage "https://github.com/thierryvolpiatto/eldoc-eval"
  url "http://elpa.gnu.org/packages/eldoc-eval-0.1.el"
  sha256 "29bca7ec12e5154cc2b70e33759ee77fc1b1457a15fb40128e83c06475ebd0d6"
  head "https://github.com/thierryvolpiatto/eldoc-eval.git"

  depends_on :emacs => "24.4"

  def install
    mv "eldoc-eval-#{version}.el", "eldoc-eval.el"
    byte_compile "eldoc-eval.el"
    (share/"emacs/site-lisp/eldoc-eval").install "eldoc-eval.el",
                                                 "eldoc-eval.elc"
    doc.install "README.md" if build.head?
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (autoload 'eldoc-in-minibuffer-mode "eldoc-eval")
    (eldoc-in-minibuffer-mode 1)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/eldoc-eval")
      (load "eldoc-eval")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

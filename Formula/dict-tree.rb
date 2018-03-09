require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DictTree < EmacsFormula
  desc "Emacs implementation of the dictionary data structure"
  homepage "http://www.dr-qubit.org/emacs_data-structures.html"
  url "https://elpa.gnu.org/packages/dict-tree-0.14.el"
  sha256 "58968bccc400a3fa7e28d6fb16f05202537c16e9abe72d633ef82d10ca9800cc"

  bottle :disable

  depends_on EmacsRequirement
  depends_on "dunn/emacs/heap-emacs"
  depends_on "dunn/emacs/tnfa-emacs"
  depends_on "dunn/emacs/trie-emacs"

  def install
    mv "dict-tree-#{version}.el", "dict-tree.el"
    byte_compile "dict-tree.el"
    elisp.install "dict-tree.el", "dict-tree.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["trie-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["heap-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["tnfa-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["queue-emacs"].opt_elisp}")
      (load "dict-tree")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

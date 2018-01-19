require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TrieEmacs < EmacsFormula
  desc "Emacs implementation of the trie data structure"
  homepage "http://www.dr-qubit.org/emacs_data-structures.html"
  url "https://elpa.gnu.org/packages/trie-0.4.el"
  sha256 "fcfdd790aa91557dc1dd6b970327161d86b9ca5a6fa7c649a2b1c3b70674c920"

  bottle :disable

  # for the avl-tree package
  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/heap-emacs"
  depends_on "dunn/emacs/tnfa-emacs"

  def install
    mv "trie-#{version}.el", "trie.el"
    byte_compile "trie.el"
    elisp.install "trie.el", "trie.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/heap-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/tnfa-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/queue-emacs"].opt_elisp}")
      (load "trie")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

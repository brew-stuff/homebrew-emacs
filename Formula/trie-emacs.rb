require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TrieEmacs < EmacsFormula
  desc "Emacs implementation of the trie data structure"
  homepage "http://www.dr-qubit.org/Emacs_data_structure_packages.html"
  url "https://elpa.gnu.org/packages/trie-0.2.6.el"
  sha256 "3112d165951b4bb84e64214373ae7f19eebf8948b0ee8b6158839582610b71e0"

  # for the avl-tree package
  depends_on emacs: "24.1"
  depends_on "homebrew/emacs/heap-emacs"
  depends_on "homebrew/emacs/tnfa-emacs"

  def install
    mv "trie-#{version}.el", "trie.el"
    byte_compile "trie.el"
    elisp.install "trie.el", "trie.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/heap-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/tnfa-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/queue-emacs"].opt_elisp}")
      (load "trie")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

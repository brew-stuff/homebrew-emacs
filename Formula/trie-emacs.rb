require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TrieEmacs < EmacsFormula
  desc "Emacs implementation of the trie data structure"
  homepage "http://www.dr-qubit.org/Emacs_data_structure_packages.html"
  url "https://elpa.gnu.org/packages/trie-0.2.6.el"
  sha256 "3112d165951b4bb84e64214373ae7f19eebf8948b0ee8b6158839582610b71e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b32170d8f8f4b81c70f9edc6562025e069f1459d78e6ee7989c96105eef8892" => :sierra
    sha256 "1b32170d8f8f4b81c70f9edc6562025e069f1459d78e6ee7989c96105eef8892" => :el_capitan
    sha256 "1b32170d8f8f4b81c70f9edc6562025e069f1459d78e6ee7989c96105eef8892" => :yosemite
  end

  # for the avl-tree package
  depends_on emacs: "24.1"
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

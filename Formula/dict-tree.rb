require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DictTree < EmacsFormula
  desc "Emacs implementation of the dictionary data structure"
  homepage "http://www.dr-qubit.org/Emacs_data_structure_packages.html"
  url "https://elpa.gnu.org/packages/dict-tree-0.12.8.el"
  sha256 "457b6b3a0a103616ba54cfb48381e9a42f6a685a9164477ef88e25acb08b4a22"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c55b749791552d0b990f565b5b94ca571cae46356e7be92f3dd41a862f11c0c" => :sierra
    sha256 "6c55b749791552d0b990f565b5b94ca571cae46356e7be92f3dd41a862f11c0c" => :el_capitan
    sha256 "6c55b749791552d0b990f565b5b94ca571cae46356e7be92f3dd41a862f11c0c" => :yosemite
  end

  depends_on :emacs
  depends_on "homebrew/emacs/heap-emacs"
  depends_on "homebrew/emacs/tnfa-emacs"
  depends_on "homebrew/emacs/trie-emacs"

  def install
    mv "dict-tree-#{version}.el", "dict-tree.el"
    byte_compile "dict-tree.el"
    elisp.install "dict-tree.el", "dict-tree.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
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

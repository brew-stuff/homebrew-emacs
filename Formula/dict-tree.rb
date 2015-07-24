require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DictTree < EmacsFormula
  desc "Emacs implementation of the dictionary data structure"
  homepage "http://www.dr-qubit.org/emacs.php"
  url "http://elpa.gnu.org/packages/dict-tree-0.12.8.el"
  sha256 "457b6b3a0a103616ba54cfb48381e9a42f6a685a9164477ef88e25acb08b4a22"

  # due to trie.el
  depends_on :emacs => "24.1"
  depends_on "dunn/emacs/heap-emacs"
  depends_on "dunn/emacs/tnfa-emacs"
  depends_on "dunn/emacs/trie-emacs"

  def install
    mv "dict-tree-#{version}.el", "dict-tree.el"
    byte_compile "dict-tree.el"
    (share/"emacs/site-lisp/dict-tree").install "dict-tree.el",
                                                "dict-tree.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "dict-tree")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

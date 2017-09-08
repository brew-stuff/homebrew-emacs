require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class UndoTree < EmacsFormula
  desc "Branching undo mode for Emacs"
  homepage "http://www.dr-qubit.org/undo-tree.html"
  url "https://elpa.gnu.org/packages/undo-tree-0.6.5.el"
  sha256 "67b4842cc3cafa5a8b15adc89e6db37e8367f5078fd2d4d5df723ade7d3f492f"
  head "http://www.dr-qubit.org/git/undo-tree.git"

  bottle :disable

  depends_on :emacs

  def install
    mv "undo-tree-#{version}.el", "undo-tree.el" if build.stable?

    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "undo-tree")
      (global-undo-tree-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

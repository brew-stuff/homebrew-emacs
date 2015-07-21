class UndoTree < Formula
  desc "Branching undo mode for Emacs"
  homepage "http://www.dr-qubit.org/emacs.php#undo-tree"
  url "http://www.dr-qubit.org/download.php?file=undo-tree/undo-tree-0.6.4.el"
  sha256 "e92f0cf9629c755108f92af26a6587a41e77fa3b9228511d97feb5154f50d201"
  head "http://www.dr-qubit.org/git/undo-tree.git"

  def install
    version_string = build.stable? ? "-#{version}" : ""
    (share/"emacs/site-lisp/undo-tree").install "undo-tree#{version_string}.el" => "undo-tree.el"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "undo-tree")
      (global-undo-tree-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

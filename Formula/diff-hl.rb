require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DiffHl < EmacsFormula
  desc "Emacs modes for highlighting uncommitted changes"
  homepage "https://github.com/dgutov/diff-hl"
  url "https://github.com/dgutov/diff-hl/archive/1.8.3.tar.gz"
  sha256 "3d6ac0ab6c24128382559bcbfe0120033c115fe44a3cb8bfc1e0a9274942082c"
  head "https://github.com/dgutov/diff-hl.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "diff-hl")
      (turn-on-diff-hl-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

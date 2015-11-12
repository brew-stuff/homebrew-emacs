require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DiffHl < EmacsFormula
  desc "Emacs modes for highlighting uncommitted changes"
  homepage "https://github.com/dgutov/diff-hl"
  url "http://elpa.gnu.org/packages/diff-hl-1.8.1.tar"
  sha256 "c4c8a6e356b833b1bb4b54454582e39c10221254c6a5d7da9f33cedac351d827"
  head "https://github.com/dgutov/diff-hl.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/diff-hl")
      (load "diff-hl")
      (turn-on-diff-hl-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

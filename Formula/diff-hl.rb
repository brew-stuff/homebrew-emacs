require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DiffHl < EmacsFormula
  desc "Emacs modes for highlighting uncommitted changes"
  homepage "https://github.com/dgutov/diff-hl"
  url "http://elpa.gnu.org/packages/diff-hl-1.8.0.tar"
  sha256 "908f08b27a324789585e10f1823233bde23f28b28fe23019c0050e0ddf19d38c"
  head "https://github.com/dgutov/diff-hl.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/diff-hl").install Dir["*.el"],
                                              Dir["*.elc"]
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

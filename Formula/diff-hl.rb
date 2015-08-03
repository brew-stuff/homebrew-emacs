require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DiffHl < EmacsFormula
  desc "Emacs modes for highlighting uncommitted changes"
  homepage "https://github.com/dgutov/diff-hl"
  url "http://elpa.gnu.org/packages/diff-hl-1.7.0.tar"
  sha256 "4171f2da46fc33e51010875555477e86962976780a66e8b388ca8237fba43681"
  head "https://github.com/dgutov/diff-hl.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/diff-hl").install Dir["*.el"],
                                              Dir["*.elc"]
    doc.install "README.md" if build.head?
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'diff-hl)
  EOS
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

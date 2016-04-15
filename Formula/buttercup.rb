require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Buttercup < EmacsFormula
  desc "Behavior-driven Emacs Lisp testing"
  homepage "https://github.com/jorgenschaefer/emacs-buttercup/"
  url "https://github.com/jorgenschaefer/emacs-buttercup/archive/v1.5.tar.gz"
  sha256 "d694a00de0828b4c8c554ed394076e37ba32e67e8bf6afb779abd7fc4baa2757"
  head "https://github.com/jorgenschaefer/emacs-buttercup.git"

  depends_on :emacs

  def install
    system "make", "test"
    system "make", "compile"
    elisp.install Dir["*.el"], Dir["*.elc"]

    inreplace "bin/buttercup", "-l buttercup", "-L #{elisp} -l buttercup"
    bin.install "bin/buttercup"
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "buttercup")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

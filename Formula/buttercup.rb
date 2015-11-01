require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Buttercup < EmacsFormula
  desc "Behavior-driven Emacs Lisp testing"
  homepage "https://github.com/jorgenschaefer/emacs-buttercup/"
  url "https://github.com/jorgenschaefer/emacs-buttercup/archive/v1.1.tar.gz"
  sha256 "c63ca6646962c325ebd8db747fe558e6366cf397633864153487db4f99d1b9d7"
  head "https://github.com/jorgenschaefer/emacs-buttercup.git"

  depends_on :emacs

  def install
    system "make", "test"
    system "make", "compile"
    elisp.install Dir["*.el"], Dir["*.elc"]

    inreplace "bin/buttercup", "-l buttercup", "-L #{elisp} -l buttercup"
    bin.install "bin/buttercup"
    doc.install Dir["doc/*"]
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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Buttercup < EmacsFormula
  desc "Behavior-driven Emacs Lisp testing"
  homepage "https://github.com/jorgenschaefer/emacs-buttercup/"
  url "https://github.com/jorgenschaefer/emacs-buttercup/archive/v1.7.tar.gz"
  sha256 "844e9bec68767d2c077655c9d0ad290fba8fca674586220475ae7df4c54d13e9"
  head "https://github.com/jorgenschaefer/emacs-buttercup.git"

  depends_on :emacs => "24.1"

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

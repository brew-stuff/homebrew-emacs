require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Wgrep < EmacsFormula
  desc "Writeable grep buffers for Emacs"
  homepage "https://github.com/mhayashi1120/Emacs-wgrep"
  url "https://github.com/mhayashi1120/Emacs-wgrep/archive/2.1.10.tar.gz"
  sha256 "819219bafe76fa8b5f3e5eb50c46e23c0d47ce0c5d84ae9b791d9cacaebf4be4"
  head "https://github.com/mhayashi1120/Emacs-wgrep.git"

  depends_on :emacs => "22.1"

  def install
    system "make", "compile"
    system "make", "check"

    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/wgrep")
      (load "wgrep")
      (wgrep-check-buffer)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

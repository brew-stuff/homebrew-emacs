require File.expand_path("../../Homebrew/emacs-formula", __FILE__)

class Wgrep < EmacsFormula
  desc "Writeable grep buffers for Emacs"
  homepage "https://github.com/mhayashi1120/Emacs-wgrep"
  head "https://github.com/mhayashi1120/Emacs-wgrep.git"

  depends_on :emacs => "24.1"

  def install
    system "make", "compile"
    system "make", "check"

    (share/"emacs/site-lisp/wgrep").install Dir["*.el"],
                                            Dir["*.elc"]
    doc.install "README.md"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "wgrep")
      (wgrep-check-buffer)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

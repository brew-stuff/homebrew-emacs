require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AutoOverlays < EmacsFormula
  desc "Emacs library for creating overlays based on regular expressions"
  homepage "http://www.dr-qubit.org/emacs.php#overlay"
  url "http://elpa.gnu.org/packages/auto-overlays-0.10.9.tar"
  sha256 "97840d265d7656e8e1488dcd08d2f037017d0afae1a46a430ab19e36d7b8122b"
  head "http://www.dr-qubit.org/git/predictive.git"

  depends_on :emacs

  def install
    # head is a joint repository so it doesn't include documentation
    # specific to auto-overlays
    if build.stable?
      info.install "auto-overlay-manual.info"
      doc.install "README"
    end

    byte_compile Dir["auto-overlay*.el"]
    (share/"emacs/site-lisp/auto-overlays").install Dir["auto-overlay*"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/auto-overlays")
      (load "auto-overlays")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

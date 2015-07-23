require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AdaptiveWrap < EmacsFormula
  desc "Emacs minor mode for smart soft-wrapping"
  homepage "http://elpa.gnu.org/packages/adaptive-wrap.html"
  url "http://elpa.gnu.org/packages/adaptive-wrap-0.5.el"
  sha256 "fefa54ba670b84360d2602fae477642b27ca4c2312983a7d24b4e6bcd1ad2f3b"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/adaptive-wrap/adaptive-wrap.el"

  depends_on :emacs

  def install
    mv "adaptive-wrap-#{version}.el", "adaptive-wrap.el" if build.stable?

    byte_compile "adaptive-wrap.el"
    (share/"emacs/site-lisp/adaptive-wrap").install "adaptive-wrap.el",
                                                    "adaptive-wrap.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'adaptive-wrap)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "adaptive-wrap")
      (adaptive-wrap-prefix-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Javaimp < EmacsFormula
  desc "Emacs functions for managing Java imports in Maven projects"
  homepage "http://elpa.gnu.org/packages/javaimp.html"
  url "http://elpa.gnu.org/packages/javaimp-0.5.el"
  sha256 "6d85bae143e632144157bbe5a5654f143b8f5da77dab9c6323112af7220d4ff5"

  depends_on :emacs

  def install
    mv "javaimp-#{version}.el", "javaimp.el"
    byte_compile "javaimp.el"
    (share/"emacs/site-lisp/javaimp").install "javaimp.el",
                                              "javaimp.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'javaimp)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "javaimp")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

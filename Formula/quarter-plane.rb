require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class QuarterPlane < EmacsFormula
  desc "Emacs minor mode for quarter-plane style editing"
  homepage "http://elpa.gnu.org/packages/quarter-plane.html"
  url "http://elpa.gnu.org/packages/quarter-plane-0.1.el"
  sha256 "b5f2fbdffb9000f9035aac89c9bb78f9daacc2f1a977ed8244b000f79b564342"

  depends_on :emacs

  def install
    mv "quarter-plane-#{version}.el", "quarter-plane.el"
    byte_compile "quarter-plane.el"
    (share/"emacs/site-lisp/quarter-plane").install "quarter-plane.el",
                                                    "quarter-plane.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'quarter-plane)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "quarter-plane")
      (quarter-plane-delete-whitespace)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

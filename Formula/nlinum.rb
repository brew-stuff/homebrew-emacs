require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Nlinum < EmacsFormula
  desc "Emacs mode for displaying line numbers in the margin"
  homepage "http://elpa.gnu.org/packages/nlinum.html"
  url "http://elpa.gnu.org/packages/nlinum-1.6.el"
  sha256 "9cdd586dfd5078951b9ec1211071da688b5b09a2cd59d191f6cc01bcbae225c3"

  depends_on :emacs

  def install
    mv "nlinum-#{version}.el", "nlinum.el"
    byte_compile "nlinum.el"
    (share/"emacs/site-lisp/nlinum").install "nlinum.el",
                                             "nlinum.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'nlinum)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/nlinum")
      (load "nlinum")
      (nlinum-mode)
      (print nlinum--width)
    EOS
    assert_equal "2", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

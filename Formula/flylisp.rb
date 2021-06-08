require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Flylisp < EmacsFormula
  desc "Emacs minor mode for coloring incorrect parentheses"
  homepage "http://elpa.gnu.org/packages/flylisp.html"
  url "http://elpa.gnu.org/packages/flylisp-0.2.el"
  sha256 "6693ed3b4ca7914470326619302bc568520243c83611a8a9289bf21e3c4e0042"

  depends_on EmacsRequirement => "24.3"

  def install
    mv "flylisp-#{version}.el", "flylisp.el"
    byte_compile "flylisp.el"
    (share/"emacs/site-lisp/flylisp").install "flylisp.el",
                                              "flylisp.elc"
  end

  def caveats
    <<~EOS
      Add the following to your init file:

      (require 'flylisp)
    EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/flylisp")
      (load "flylisp")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../Homebrew/emacs_formula", __dir__)

class LexEmacs < EmacsFormula
  desc "Lexical analyser construction"
  homepage "http://elpa.gnu.org/packages/lex.html"
  url "http://elpa.gnu.org/packages/lex-1.1.tar"
  sha256 "672dfebb43ea57cf05718b3bd9a72ce7967d5b3dc6f36aa18dcf8a25e688d9c4"

  depends_on EmacsRequirement
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/lex").install Dir["*.el"],
                                          Dir["*.elc"]
  end

  def caveats
    <<~EOS
      Add the following to your init file:

      (require 'lex)
    EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/lex")
      (load "lex")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

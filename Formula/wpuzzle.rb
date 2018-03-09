require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Wpuzzle < EmacsFormula
  desc "Emacs word search game"
  homepage "http://elpa.gnu.org/packages/wpuzzle.html"
  url "http://elpa.gnu.org/packages/wpuzzle-1.1.el"
  sha256 "720a03df4a09437790c222effd7fb461b09fdd8be34c85ac90db01d642204ff2"

  depends_on EmacsRequirement
  depends_on "aspell" => "with-lang-en"

  def install
    mv "wpuzzle-#{version}.el", "wpuzzle.el"
    byte_compile "wpuzzle.el"
    (share/"emacs/site-lisp/wpuzzle").install "wpuzzle.el",
                                              "wpuzzle.elc"
  end

  def caveats; <<~EOS
    Add the following to your init file:

    (require 'wpuzzle)
  EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/wpuzzle")
      (load "wpuzzle")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

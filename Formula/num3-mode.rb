require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Num3Mode < EmacsFormula
  desc "Emacs minor mode to highlight long numbers for readability"
  homepage "http://elpa.gnu.org/packages/num3-mode.html"
  url "http://elpa.gnu.org/packages/num3-mode-1.2.el"
  sha256 "a8ad0b2181a6024fdff2cff93c6d03dcc95dc430eb1d3215c1d9685caef4a3da"

  depends_on EmacsRequirement

  def install
    mv "num3-mode-#{version}.el", "num3-mode.el"
    byte_compile "num3-mode.el"
    (share/"emacs/site-lisp/num3-mode").install "num3-mode.el",
                                                "num3-mode.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'num3-mode)
    (global-num3-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/num3-mode")
      (load "num3-mode")
      (global-num3-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

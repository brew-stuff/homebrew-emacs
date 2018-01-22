require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class MinibufferLine < EmacsFormula
  desc "Emacs package to display information in the minibuffer"
  homepage "http://elpa.gnu.org/packages/minibuffer-line.html"
  url "http://elpa.gnu.org/packages/minibuffer-line-0.1.el"
  sha256 "345e7d38063c949d270535b5d53e652dd3eecca6fd398e4228ca1a71738cc4db"

  depends_on EmacsRequirement

  def install
    mv "minibuffer-line-#{version}.el", "minibuffer-line.el"
    byte_compile "minibuffer-line.el"
    (share/"emacs/site-lisp/minibuffer-line").install "minibuffer-line.el",
                                                      "minibuffer-line.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'minibuffer-line)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/minibuffer-line")
      (load "minibuffer-line")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

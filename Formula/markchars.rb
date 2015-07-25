require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Markchars < EmacsFormula
  desc "Emacs modes for marking special characters"
  homepage "http://elpa.gnu.org/packages/markchars.html"
  url "http://elpa.gnu.org/packages/markchars-0.2.0.el"
  sha256 "1b12ffda377f5769ec13f6ea674b492779f79e9669a0c261e7057bf665dac9f2"

  depends_on :emacs

  def install
    mv "markchars-#{version}.el", "markchars.el"
    byte_compile "markchars.el"
    (share/"emacs/site-lisp/markchars").install "markchars.el",
                                                "markchars.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'markchars)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "markchars")
      (markchars-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

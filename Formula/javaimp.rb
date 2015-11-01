require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Javaimp < EmacsFormula
  desc "Emacs functions for Java imports in Maven projects"
  homepage "http://elpa.gnu.org/packages/javaimp.html"
  url "http://elpa.gnu.org/packages/javaimp-0.6.el"
  sha256 "10df463d9ba48a18116bea94fcff30c4e96c8c3a7397a08228fe2f9eb63c4301"

  depends_on :emacs

  def install
    mv "javaimp-#{version}.el", "javaimp.el"
    byte_compile "javaimp.el"
    (share/"emacs/site-lisp/javaimp").install "javaimp.el", "javaimp.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/javaimp")
      (load "javaimp")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

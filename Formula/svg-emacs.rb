require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SvgEmacs < EmacsFormula
  desc "Emacs functions for creating scalable vector graphics"
  homepage "http://elpa.gnu.org/packages/svg.html"
  url "http://elpa.gnu.org/packages/svg-0.1.el"
  sha256 "65af4fc190d066c35865c6b23380e6917d30354984af5ca952526e69b562476c"

  depends_on :emacs
  depends_on "homebrew/emacs/dom-emacs"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    mv "svg-#{version}.el", "svg.el"
    byte_compile "svg.el"
    elisp.install "svg.el", "svg.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dom-emacs"].opt_elisp}")
      (load "svg")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

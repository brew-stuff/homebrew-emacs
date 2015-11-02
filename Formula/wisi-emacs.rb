require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WisiEmacs < EmacsFormula
  desc "Indentation/navigation in Emacs using LALR parsers"
  homepage "http://elpa.gnu.org/packages/wisi.html"
  url "http://elpa.gnu.org/packages/wisi-1.1.1.tar"
  sha256 "797845efd2358d76d5281f45c19e521a7c7121549128eb43250b3d3b4f8e7791"

  depends_on :emacs => "24.2"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "wisi")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

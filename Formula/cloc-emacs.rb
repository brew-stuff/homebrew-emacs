require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ClocEmacs < EmacsFormula
  desc "LOC-counting functions for Emacs"
  homepage "https://github.com/cosmicexplorer/cloc-emacs"
  head "https://github.com/cosmicexplorer/cloc-emacs.git"

  depends_on EmacsRequirement
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile "cloc.el"
    (share/"emacs/site-lisp/cloc").install "cloc.el", "cloc.elc"
    doc.install "README.md"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/cloc")
      (load "cloc")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

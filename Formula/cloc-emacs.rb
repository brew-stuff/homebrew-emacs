require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ClocEmacs < EmacsFormula
  desc "LOC-counting functions for Emacs"
  homepage "https://github.com/cosmicexplorer/cloc-emacs"
  head "https://github.com/cosmicexplorer/cloc-emacs.git"

  depends_on :emacs
  depends_on "dunn/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile "cloc.el"
    (share/"emacs/site-lisp/cloc").install "cloc.el", "cloc.elc"
    doc.install "README.md"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "cloc")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

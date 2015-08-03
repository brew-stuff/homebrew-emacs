require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DomEmacs < EmacsFormula
  desc "Emacs library for the Document Object Model"
  homepage "https://github.com/toroidal-code/dom.el"
  head "https://github.com/toroidal-code/dom.el.git"

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile "dom.el"
    (share/"emacs/site-lisp/dom").install "dom.el",
                                          "dom.elc"
    doc.install "README.md"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/dom")
      (load "dom")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

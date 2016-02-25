require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Sotlisp < EmacsFormula
  desc "Emacs minor mode for writing Emacs Lisp faster"
  homepage "https://github.com/Malabarba/speed-of-thought-lisp"
  url "https://elpa.gnu.org/packages/sotlisp-1.5.1.el"
  sha256 "753ea8a2e4c0844a97c4a66c34a424200d3ab6d1c8504969892f241009bda2b6"
  head "https://github.com/Malabarba/speed-of-thought-lisp.git"

  depends_on :emacs => "24.1"

  def install
    mv "sotlisp-#{version}.el", "sotlisp.el" if build.stable?
    byte_compile "sotlisp.el"
    elisp.install "sotlisp.el", "sotlisp.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "sotlisp")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

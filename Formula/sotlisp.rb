require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Sotlisp < EmacsFormula
  desc "Emacs minor mode for writing Emacs Lisp faster"
  homepage "https://github.com/Malabarba/speed-of-thought-lisp"
  url "https://elpa.gnu.org/packages/sotlisp-1.6.2.el"
  sha256 "11da016428df7e9739dc7f652eee87cde065b307d0b1250faf8b93076b239915"
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

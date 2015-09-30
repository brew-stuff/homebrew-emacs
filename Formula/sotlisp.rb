require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Sotlisp < EmacsFormula
  desc "Emacs minor mode for writing Emacs Lisp faster"
  homepage "https://github.com/Malabarba/speed-of-thought-lisp"
  url "https://github.com/Malabarba/speed-of-thought-lisp/archive/1.4.tar.gz"
  sha256 "23b33570d72039ca431f777c2ea94ab95c54df47dac5b40e54fd9c223fe96a89"
  head "https://github.com/Malabarba/speed-of-thought-lisp.git"

  depends_on :emacs => "24.1"

  def install
    byte_compile "sotlisp.el"
    (share/"emacs/site-lisp/sotlisp").install "sotlisp.el",
                                              "sotlisp.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/sotlisp")
      (load "sotlisp")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Sotlisp < EmacsFormula
  desc "Emacs minor mode for writing Emacs Lisp faster"
  homepage "https://github.com/Malabarba/speed-of-thought-lisp"
  url "https://github.com/Malabarba/speed-of-thought-lisp/archive/1.4.1.tar.gz"
  sha256 "1cefb4cb1a7e1f4093cdfa4980dc003f2ba3857a593d1dc983888a8f01504648"
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

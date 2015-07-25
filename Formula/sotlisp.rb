require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Sotlisp < EmacsFormula
  desc "Emacs minor mode for writing Emacs Lisp faster"
  homepage "https://github.com/Malabarba/speed-of-thought-lisp"
  url "https://github.com/Malabarba/speed-of-thought-lisp/archive/1.1.tar.gz"
  sha256 "1150b4478a323e7332c665a9eddb390f10719a5363562d4bde75f1f6bf537dd4"
  head "https://github.com/Malabarba/speed-of-thought-lisp.git"

  depends_on :emacs => "24.1"

  def install
    byte_compile "sotlisp.el"
    (share/"emacs/site-lisp/sotlisp").install "sotlisp.el",
                                              "sotlisp.elc"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'sotlisp)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "sotlisp")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

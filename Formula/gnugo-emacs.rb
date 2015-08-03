require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class GnugoEmacs < EmacsFormula
  desc "Emacs interface to GNU Go"
  homepage "http://www.gnuvola.org/software/gnugo/"
  url "http://elpa.gnu.org/packages/gnugo-3.0.0.tar"
  sha256 "fd082e88944bf607c6bf115753d0670f6c21a5bc33595c271f02e4d8f19a242d"

  depends_on :emacs
  depends_on "homebrew/games/gnu-go"
  depends_on "homebrew/emacs/ascii-art-to-unicode"
  depends_on "homebrew/emacs/xpm-emacs"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/gnugo").install Dir["*.el"], Dir["*.elc"]
    doc.install "README", "HACKING"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'gnugo)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/gnugo")
      (load "gnugo")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

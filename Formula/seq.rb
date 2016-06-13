require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Seq < EmacsFormula
  desc "Sequence manipulation library for Emacs"
  homepage "https://elpa.gnu.org/packages/seq.html"
  url "https://elpa.gnu.org/packages/seq-2.16.tar"
  sha256 "6ac63594fa2d53e524b007283cd183100192fb9d8bbcfde17c3dd3b1966481b9"
  head "https://github.com/NicolasPetton/seq.el.git"

  depends_on :emacs

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/seq")
      (load "seq")
      (print (seq-max '(1 5 10)))
    EOS
    assert_equal "10", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

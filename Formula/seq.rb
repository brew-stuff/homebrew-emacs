require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Seq < EmacsFormula
  desc "Sequence manipulation library for Emacs"
  homepage "http://elpa.gnu.org/packages/seq.html"
  url "http://elpa.gnu.org/packages/seq-1.11.el"
  sha256 "30ccb62dc6d2d216b5acdeb5ed5d9ce1b85893d84158bae233ddf8db19a9eae2"
  head "https://github.com/NicolasPetton/seq.el.git"

  depends_on :emacs

  def install
    mv "seq-#{version}.el", "seq.el" if build.stable?
    byte_compile "seq.el"
    (share/"emacs/site-lisp/seq").install "seq.el", "seq.elc"
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

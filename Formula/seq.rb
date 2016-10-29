require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Seq < EmacsFormula
  desc "Sequence manipulation library for Emacs"
  homepage "https://elpa.gnu.org/packages/seq.html"
  url "https://elpa.gnu.org/packages/seq-2.19.tar"
  sha256 "0a7e93f52bb7afd28d36c1362f7da9e301694e813f3b2699a6011265743c0b86"

  depends_on :emacs => "24.1"

  # Submitted upstream via email on 2016-10-28
  patch :p3 do
    url "https://github.com/dunn/elpa/commit/195320c704cbc721f945d59fa54cd20d8e024a57.diff"
    sha256 "f4967cac92cfe462eca073c27db1422299acae5d0a99cacac8c14555ab616142"
  end

  def install
    ert_run_tests "tests/seq-tests.el"
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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Dash < EmacsFormula
  desc "A modern list library for Emacs"
  homepage "https://github.com/magnars/dash.el"
  url "https://github.com/magnars/dash.el/archive/2.12.0.tar.gz"
  sha256 "c6db3a237747b02d20382a761397563d813b306c020ae28ce25a1c3915fac60f"
  head "https://github.com/magnars/dash.el.git"

  depends_on :emacs => "24.1"

  def install
    system "./run-tests.sh"
    system "./create-docs.sh"
    (share/"emacs/site-lisp/dash").install Dir["*.el"],
                                           Dir["*.elc"]
    doc.install Dir["*.texi"]
    info.install "dash.info"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/dash")
      (load "dash")
      (print (--map (* it it) '(1 2 3 4)))
    EOS
    assert_equal "(1 4 9 16)", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

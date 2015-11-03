require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DashEmacs < EmacsFormula
  desc "Modern list library for Emacs"
  homepage "https://github.com/magnars/dash.el"
  url "https://github.com/magnars/dash.el/archive/2.12.0.tar.gz"
  sha256 "272b337f31edb95c5aadc8e953d522bd307dc522588f246cc9157edee10b1a76"
  head "https://github.com/magnars/dash.el.git"

  depends_on :emacs => "24.1"

  def install
    system "./run-tests.sh"
    elisp.install Dir["*.el"], Dir["*.elc"]
    info.install "dash.info"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "dash")
      (print (--map (* it it) '(1 2 3 4)))
    EOS
    assert_equal "(1 4 9 16)", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

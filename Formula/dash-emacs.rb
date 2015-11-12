require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DashEmacs < EmacsFormula
  desc "Modern list library for Emacs"
  homepage "https://github.com/magnars/dash.el"
  url "https://github.com/magnars/dash.el/archive/2.12.1.tar.gz"
  sha256 "41460193aa74787b247b09ad7cae696016110abba2a922ef1a067472eba15220"
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

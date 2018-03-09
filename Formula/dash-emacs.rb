require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DashEmacs < EmacsFormula
  desc "Modern list library for Emacs"
  homepage "https://github.com/magnars/dash.el"
  url "https://github.com/magnars/dash.el/archive/2.13.0.tar.gz"
  sha256 "0bc298129ff3421ba2de87b95c157fe35be0f7f26de83eae5d8558947f9e54de"
  head "https://github.com/magnars/dash.el.git"

  bottle :unneeded

  depends_on EmacsRequirement => "24.1"

  def install
    system "./run-tests.sh"
    elisp.install Dir["*.el"], Dir["*.elc"]
    info.install "dash.info"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "dash")
      (print (--map (* it it) '(1 2 3 4)))
    EOS
    assert_equal "(1 4 9 16)", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

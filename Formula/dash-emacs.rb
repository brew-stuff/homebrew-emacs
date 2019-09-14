require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DashEmacs < EmacsFormula
  desc "Modern list library for Emacs"
  homepage "https://github.com/magnars/dash.el"
  url "https://github.com/magnars/dash.el/archive/2.16.0.tar.gz"
  sha256 "a9a1e45bf158c6bef506a4835f2f2686087bddcaa4525c59f554636d4d965ba0"
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

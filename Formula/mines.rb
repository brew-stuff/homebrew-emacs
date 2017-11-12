require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Mines < EmacsFormula
  desc "Emacs implementation of Minesweeper"
  homepage "https://github.com/calancha/Minesweeper"
  url "https://github.com/calancha/Minesweeper/archive/mines_v1.2.tar.gz"
  sha256 "b8418532a599d8c30c9ba3e16f68e8f4d6002599dba9fc611764a12b1d04ff81"
  head "https://github.com/calancha/Minesweeper.git"

  bottle :disable

  depends_on EmacsRequirement => "24.4"

  def install
    system "make", "compile"
    elisp.install "mines.el", "mines.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "mines")
      (mines)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

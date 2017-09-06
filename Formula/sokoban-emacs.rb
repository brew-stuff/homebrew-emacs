require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SokobanEmacs < EmacsFormula
  desc "Emacs version of Sokoban"
  homepage "https://elpa.gnu.org/packages/sokoban.html"
  url "https://elpa.gnu.org/packages/sokoban-1.4.5.tar"
  sha256 "37c279b68ee5c558a3d4f027a70b8fc7c2bdcaf8f12d2d11a2aa3871c32b03c2"

  bottle :disable

  depends_on :emacs => "23.1"

  def install
    byte_compile "sokoban.el"
    elisp.install "sokoban.el", "sokoban.elc", "sokoban.levels"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "sokoban")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

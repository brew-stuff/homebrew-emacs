require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SokobanEmacs < EmacsFormula
  desc "Emacs version of Sokoban"
  homepage "https://elpa.gnu.org/packages/sokoban.html"
  url "https://elpa.gnu.org/packages/sokoban-1.4.tar"
  sha256 "8127798c25bb19ae8d9a4d8d9d3e24b43a5a1ec45b0c79f1003a66991157d3f9"

  depends_on emacs: "19.34"

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"], "sokoban.levels"
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

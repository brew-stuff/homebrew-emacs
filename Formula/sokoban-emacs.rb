require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SokobanEmacs < EmacsFormula
  desc "Emacs version of Sokoban"
  homepage "https://elpa.gnu.org/packages/sokoban.html"
  url "https://elpa.gnu.org/packages/sokoban-1.4.6.tar"
  sha256 "f62f775b74d223f2b53b30f8356e6bc751f74d8a3d07c459c2c57e3368a04c84"

  bottle :disable

  depends_on EmacsRequirement => "23.1"

  def install
    byte_compile "sokoban.el"
    elisp.install "sokoban.el", "sokoban.elc", "sokoban.levels"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "sokoban")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

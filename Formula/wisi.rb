require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Wisi < EmacsFormula
  desc "Indentation/navigation in Emacs using a LALR parser"
  homepage "http://www.nongnu.org/ada-mode/wisi/wisi.html"
  url "https://elpa.gnu.org/packages/wisi-1.1.6.tar"
  sha256 "d3f26f27f8cb2932639ad054d35a5742eb1b989546597c6b06e5ae4768aaf05c"

  bottle :disable

  depends_on EmacsRequirement => "25.1"

  def install
    sources = (Dir["*.el"] - ["wisi-pkg.el"])
    byte_compile sources
    elisp.install sources, Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "wisi")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

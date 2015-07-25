require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SokobanEmacs < EmacsFormula
  desc "Emacs version of Sokoban"
  homepage "http://elpa.gnu.org/packages/sokoban.html"
  url "http://elpa.gnu.org/packages/sokoban-1.4.tar"
  sha256 "8127798c25bb19ae8d9a4d8d9d3e24b43a5a1ec45b0c79f1003a66991157d3f9"

  depends_on :emacs => "19.34"

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/sokoban").install Dir["*.el"],
                                              Dir["*.elc"],
                                              "sokoban.levels"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'sokoban)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "sokoban")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

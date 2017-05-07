require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Quack < EmacsFormula
  desc "Enhanced Emacs support for Racket and Scheme"
  homepage "http://www.neilvandyke.org/quack/"
  url "http://www.neilvandyke.org/quack/quack.el"
  sha256 "5d6f103307c9f3809f3fa9a7179a08c05add3afdf134553eae8ae19dcfccce5b"
  version "0.48"
  
  depends_on :emacs => "22.1"

  def install
    byte_compile "quack.el"
    elisp.install "quack.el", "quack.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "quack")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

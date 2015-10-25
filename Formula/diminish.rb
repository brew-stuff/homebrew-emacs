require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Diminish < EmacsFormula
  desc "Diminished modes are minor modes with no modeline display"
  homepage "http://www.eskimo.com/~seldon/"
  url "http://www.eskimo.com/~seldon/diminish.el"
  version "0.44"
  sha256 "ba7aefe7899dd0c7428a4f666c5c1391338b1197c1f163b4504abee7d9aa861c"

  def install
    byte_compile "diminish.el"
    (share/"emacs/site-lisp/diminish").install "diminish.el", "diminish.elc"
    generate_autoloads
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/diminish")
      (load "diminish")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs --quick --batch --load #{testpath}/test.el").strip
  end
end

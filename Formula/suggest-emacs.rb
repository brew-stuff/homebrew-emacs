require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SuggestEmacs < EmacsFormula
  desc "Emacs package for discovering functions"
  homepage "https://github.com/Wilfred/suggest.el"
  url "https://github.com/Wilfred/suggest.el/archive/0.4.tar.gz"
  sha256 "f7d13da6e3d31c8bc8f7e9dd645ecb011b045341da60ae58ef88a7204775c09c"
  head "https://github.com/Wilfred/suggest.el.git"

  bottle :disable

  depends_on EmacsRequirement => "24.4"
  depends_on "dunn/emacs/dash-emacs"
  depends_on "dunn/emacs/f-emacs"
  depends_on "dunn/emacs/loop-emacs"
  depends_on "dunn/emacs/s-emacs"

  def install
    byte_compile "suggest.el"
    elisp.install "suggest.el", "suggest.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{Formula["dunn/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/f-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/loop-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/s-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{elisp}")
      (load "suggest")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

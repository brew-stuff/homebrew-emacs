require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SuggestEmacs < EmacsFormula
  desc "Emacs package for discovering functions"
  homepage "https://github.com/Wilfred/suggest.el"
  url "https://github.com/Wilfred/suggest.el/archive/0.2.tar.gz"
  sha256 "02e2f87c00da1a95cdb436ba104d7fdffc1197207c38259318cd2026a1282b41"
  head "https://github.com/Wilfred/suggest.el.git"

  depends_on :emacs => "24.4"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/f-emacs"
  depends_on "homebrew/emacs/loop-emacs"
  depends_on "homebrew/emacs/s-emacs"

  def install
    byte_compile "suggest.el"
    elisp.install "suggest.el", "suggest.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/f-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/loop-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/s-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{elisp}")
      (load "suggest")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

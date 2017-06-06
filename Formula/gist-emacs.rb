require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class GistEmacs < EmacsFormula
  desc "Emacs integration with GitHub Gists"
  homepage "https://github.com/defunkt/gist.el"
  url "https://github.com/defunkt/gist.el/archive/v1.4.0.tar.gz"
  sha256 "5003cf146f6e269aab57a6c6c1c7448ba7312094fabdf76ba0688ca2e00b6893"
  head "https://github.com/defunkt/gist.el.git"

  depends_on :emacs => "24.1"
  depends_on "dunn/emacs/gh-emacs"

  def install
    byte_compile "gist.el"
    elisp.install "gist.el", "gist.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/gh-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/logito"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/pcache"].opt_elisp}")
      (load "gist")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

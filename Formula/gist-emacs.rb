require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class GistEmacs < EmacsFormula
  desc "Emacs integration for gist.github.com"
  homepage "https://github.com/defunkt/gist.el"
  url "https://github.com/defunkt/gist.el/archive/v1.3.1.tar.gz"
  sha256 "a060bc828aceba8a8c9aa850b5157cb85a8fe83987096bcc7500ae0ba86bb54b"
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

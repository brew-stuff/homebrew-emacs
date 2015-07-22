require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class LetAlist < EmacsFormula
  desc "Easily let-bind values of an assoc-list by their names"
  homepage "http://elpa.gnu.org/packages/let-alist.html"
  url "http://elpa.gnu.org/packages/let-alist-1.0.4.el"
  sha256 "1da10a090b40feb682a35c36498ba0d23d1ea8787db64d8ca3067dbff712611c"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/let-alist/let-alist.el"

  depends_on :emacs

  def install
    mv "let-alist-#{version}.el", "let-alist.el" if build.stable?

    byte_compile "let-alist.el"
    (share/"emacs/site-lisp/let-alist").install "let-alist.el",
                                                "let-alist.elc"
  end
end

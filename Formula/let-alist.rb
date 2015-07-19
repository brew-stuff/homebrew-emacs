class LetAlist < Formula
  desc "Easily let-bind values of an assoc-list by their names"
  homepage "http://elpa.gnu.org/packages/let-alist.html"
  url "http://elpa.gnu.org/packages/let-alist-1.0.4.el"
  sha256 "1da10a090b40feb682a35c36498ba0d23d1ea8787db64d8ca3067dbff712611c"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/let-alist/let-alist.el"

  def install
    version_string = build.stable? ? "-#{version}" : ""
    (share/"emacs/site-lisp/let-alist").install "let-alist#{version_string}.el" => "let-alist.el"
  end
end

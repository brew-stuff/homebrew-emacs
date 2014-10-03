require 'formula'

class OrgMode < Formula
  homepage 'http://orgmode.org/'
  url 'http://orgmode.org/org-8.2.8.tar.gz'
  sha1 'e2d1715ce97406a91edb9191c29dd8564460f9b5'

  head 'git://orgmode.org/org-mode.git'

  def install
    system "make", "all"
    (share+"emacs/site-lisp").install "lisp" => "org"
    (share+"emacs/site-lisp/org").install "contrib/lisp" => "contrib"
    info.install 'doc/org' => 'org.info'
  end
end

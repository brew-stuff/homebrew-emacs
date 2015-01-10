require 'formula'

class OrgMode < Formula
  homepage 'http://orgmode.org/'
  url 'http://orgmode.org/org-8.2.10.tar.gz'
  sha1 'fcb1c74c84387979a883431012930a0a63fc5138'

  head 'git://orgmode.org/org-mode.git'

  def install
    system "make", "all"
    (share+"emacs/site-lisp").install "lisp" => "org"
    (share+"emacs/site-lisp/org").install "contrib/lisp" => "contrib"
    info.install 'doc/org' => 'org.info'
  end
end

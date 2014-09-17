require 'formula'

class OrgMode < Formula
  homepage 'http://orgmode.org/'
  url 'http://orgmode.org/org-8.2.7c.tar.gz'
  sha1 'b824edc15a57f832df0f941ac7d00bedd8d61d25'

  head 'git://orgmode.org/org-mode.git'

  def install
    system "make", "all"
    (share+"emacs/site-lisp").install "lisp" => "org"
    (share+"emacs/site-lisp/org").install "contrib"
    info.install 'doc/org' => 'org.info'
  end
end

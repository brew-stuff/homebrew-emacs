require 'formula'

class XmlRpc < Formula
  homepage 'https://launchpad.net/xml-rpc-el'
  url 'https://launchpad.net/xml-rpc-el/trunk/1.6.8/+download/xml-rpc.el', :using => :curl
  version '1.6.8'
  sha1 '5addce61674bd08c5649085185bb2d9a22d91875'

  def install
    (share+'emacs/site-lisp').install 'xml-rpc.el'
  end
end

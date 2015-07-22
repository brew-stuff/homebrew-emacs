class XmlRpc < Formula
  homepage "https://launchpad.net/xml-rpc-el"
  url "https://launchpad.net/xml-rpc-el/trunk/1.6.8/+download/xml-rpc.el"
  version "1.6.8"
  sha256 "ebd4e582f66df200a01344cd89af428d1ae75878c2057c76c65c66e841721045"
  head "lp:xml-rpc-el", :using => :bzr

  def install
    (share/"emacs/site-lisp/xml-rpc").install "xml-rpc.el"
  end
end

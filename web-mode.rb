require 'formula'

class WebMode < Formula
  homepage 'http://web-mode.org/'
  url 'https://github.com/fxbois/web-mode/archive/v9.tar.gz'
  sha1 '03777b95ce0564cc49d017a919e02c762bab67b4'
  head 'https://github.com/fxbois/web-mode.git'

  def install
    (share+'emacs/site-lisp').install ['web-mode.el', 'wfs-mode.el']
  end
end

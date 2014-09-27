require 'formula'

class DiredDetails < Formula
  homepage 'http://www.emacswiki.org/DiredDetails'
  url 'http://www.emacswiki.org/emacs/download/dired-details.el', :using => :curl
  version '1.3.2'
  sha1 '3de7e19ae874dac03edf9951648a1f11f52dead6'

  def install
    (share+'emacs/site-lisp').install 'dired-details.el'
  end
end

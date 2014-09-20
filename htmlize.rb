require 'formula'

class Htmlize < Formula
  homepage 'http://www.emacswiki.org/emacs/Htmlize' # couldn't find a proper homepage
  url 'http://fly.srk.fer.hr/~hniksic/emacs/htmlize.git', :tag => "release/1.47"
  head 'http://fly.srk.fer.hr/~hniksic/emacs/htmlize.git'

  def install
    (share+'emacs/site-lisp').install 'htmlize.el'
  end
end

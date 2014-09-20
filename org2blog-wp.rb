require 'formula'

class Org2blogWp < Formula
  homepage 'http://punchagan.muse-amuse.in/tags/org2blog'
  head 'https://github.com/punchagan/org2blog.git'

  depends_on 'edavis/emacs/metaweblog'
  depends_on 'edavis/emacs/xml-rpc'

  def install
    (share+'emacs/site-lisp/org2blog-wp').install Dir['*.el']
  end
end

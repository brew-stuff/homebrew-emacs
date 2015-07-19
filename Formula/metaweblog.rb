require 'formula'

class Metaweblog < Formula
  homepage 'https://github.com/punchagan/metaweblog'
  head 'https://github.com/punchagan/metaweblog.git'

  def install
    (share+'emacs/site-lisp').install 'metaweblog.el'
  end
end

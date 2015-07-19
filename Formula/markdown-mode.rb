require 'formula'

class MarkdownMode < Formula
  homepage 'http://jblevins.org/projects/markdown-mode/'
  url 'http://jblevins.org/git/markdown-mode.git/snapshot/markdown-mode-2.0.tar.gz'
  sha1 'ca3f8149f0e9e771791a3fd9a25f41f6164c1557'
  head 'git://jblevins.org/git/markdown-mode.git'

  def install
    (share+'emacs/site-lisp').install 'markdown-mode.el'
  end
end

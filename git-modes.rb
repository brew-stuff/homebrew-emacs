require 'formula'

class GitModes < Formula
  homepage 'https://github.com/magit/git-modes'
  head 'https://github.com/magit/git-modes.git'

  def install
    (share+"emacs/site-lisp").install Dir['*.el']
  end
end

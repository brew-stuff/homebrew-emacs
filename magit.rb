require 'formula'

class Magit < Formula
  homepage 'https://github.com/magit/magit'
  url 'https://github.com/magit/magit/archive/1.2.1.tar.gz'
  sha1 '3faeaab35934951a746e3be834d0457ca99bdc01'

  head do
    url 'https://github.com/magit/magit.git'
    depends_on 'edavis/emacs/git-modes'
  end

  def install
    if build.head?
      inreplace "Makefile", "-L ../git-modes -L ../cl-lib", "-L #{Formula['git-modes'].opt_prefix}/share/emacs/site-lisp"
      inreplace "Makefile", "EMACS  ?= emacs", "EMACS ?= #{Formula['emacs'].opt_prefix}/bin/emacs"
    end
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
  end
end

class ScssMode < Formula
  desc "Major mode for editing .scss files in Emacs"
  homepage "https://github.com/antonj/scss-mode"
  url "https://github.com/antonj/scss-mode/archive/0.5.0.tar.gz"
  sha256 "765b06cd6f93763c5dc5903b1645d98ea9ea6f75f5d6bc96b68d979224f90812"
  head "https://github.com/antonj/scss-mode.git"

  def install
    (share/"emacs/site-lisp/scss-mode").install "scss-mode.el"
    doc.install "README.org"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

      (require 'scss-mode)
      (add-to-list 'auto-mode-alist '("\\.scss$" . scss-mode))
    EOS
  end
end

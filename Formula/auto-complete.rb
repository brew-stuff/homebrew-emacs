class AutoComplete < Formula
  desc "Autocompletion extension for Emacs"
  homepage "http://auto-complete.org/"
  url "https://github.com/auto-complete/auto-complete/archive/v1.5.0.tar.gz"
  sha256 "a960848fcb94f438c6795070b3125c1a039bf11cc058dbd60e8668adb3cebe4c"
  head "https://github.com/auto-complete/auto-complete.git"

  depends_on :emacs => "24.1"
  depends_on "cask"
  depends_on "dunn/emacs/popup"

  def install
    system "make", "test", "CASK=#{Formula["cask"].bin}/cask"

    system "make", "byte-compile", "CASK=#{Formula["cask"].bin}/cask"
    (share/"emacs/site-lisp/auto-complete").install Dir["*.el"],
                                                    Dir["*.elc"]
  end
end

require File.expand_path("../../Homebrew/emacs-formula", __FILE__)

class Popup < EmacsFormula
  desc "Visual popup interface library for Emacs"
  homepage "https://github.com/auto-complete/popup-el"
  url "https://github.com/auto-complete/popup-el/archive/v0.5.2.tar.gz"
  sha256 "19714326dd5166def540c3f1c47a27e67ffdb3a94c91271c88a8500a15846c0b"
  head "https://github.com/auto-complete/popup-el.git"

  depends_on :emacs => "23"
  depends_on "cask"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < 24

  def install
    # non-interactive test
    system "make", "travis-ci", "CASK=#{Formula["cask"].bin}/cask"

    byte_compile "popup.el"
    (share/"emacs/site-lisp/popup").install "popup.el", "popup.elc"
    doc.install "README.md"
  end
end

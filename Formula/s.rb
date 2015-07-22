require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class S < EmacsFormula
  desc "Emacs string manipulation library"
  homepage "https://github.com/magnars/s.el"
  url "https://github.com/magnars/s.el/archive/1.9.0.tar.gz"
  sha256 "2181f6d901503d0ad95b50ec063f7c3b9c9225f8f91f7e69af76bf73ca1450bd"
  head "https://github.com/magnars/s.el.git"

  depends_on :emacs => "23.1"

  def install
    system "./run-tests.sh"

    byte_compile "s.el"
    (share/"emacs/site-lisp/s").install "s.el", "s.elc"

    system "./create-docs.sh" if build.head?
    doc.install "README.md"
  end
end

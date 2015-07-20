class S < Formula
  desc "Emacs string manipulation library"
  homepage "https://github.com/magnars/s.el"
  url "https://github.com/magnars/s.el/archive/1.9.0.tar.gz"
  sha256 "2181f6d901503d0ad95b50ec063f7c3b9c9225f8f91f7e69af76bf73ca1450bd"
  head "https://github.com/magnars/s.el.git"

  depends_on :emacs => "23"

  def install
    system "./run-tests.sh"
    system "./create-docs.sh" if build.head?
    (share/"emacs/site-lisp/s").install "s.el"
    doc.install "README.md"
  end
end

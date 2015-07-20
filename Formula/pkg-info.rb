class PkgInfo < Formula
  desc "Library for providing information about Emacs packages"
  homepage "https://github.com/lunaryorn/pkg-info.el"
  url "https://github.com/lunaryorn/pkg-info.el/archive/0.6.tar.gz"
  sha256 "a5e5123f96bfa635c67ea64cf8df2b3a29e448f6ec2116de13a0d65af494c1bf"
  head "https://github.com/lunaryorn/pkg-info.el.git"

  depends_on :emacs => "24.1"
  depends_on "cask"

  def install
    system "make", "compile", "EMACS=#{which "emacs"}",
                              "CASK=#{Formula["cask"].bin}/cask"

    (share/"emacs/site-lisp/pkg-info").install Dir["*.el"],
                                               Dir["*.elc"]
    doc.install "README.md"
  end
end

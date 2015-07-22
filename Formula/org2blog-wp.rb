class Org2blogWp < Formula
  desc "Emacs package for publishing from org-mode to WordPress blogs"
  homepage "https://github.com/punchagan/org2blog"
  url "https://github.com/punchagan/org2blog/archive/v0.9.2.tar.gz"
  sha256 "28ccab8541fe79a3bc82387d3605531f99045536f23af619f3634a7b59a410f9"
  head "https://github.com/punchagan/org2blog.git"

  depends_on :emacs => "22.1"
  depends_on "dunn/emacs/metaweblog"
  depends_on "dunn/emacs/org-mode"
  depends_on "dunn/emacs/xml-rpc"

  def install
    # tests are interactive so we can't run them
    (share/"emacs/site-lisp/org2blog-wp").install Dir["*.el"]
    doc.install "README.org"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'org2blog-autoloads)
  EOS
  end
end

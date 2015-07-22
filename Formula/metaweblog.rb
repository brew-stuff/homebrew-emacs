class Metaweblog < Formula
  desc "Emacs library to access metaweblog-based weblogs"
  homepage "https://github.com/punchagan/metaweblog"
  url "https://github.com/punchagan/metaweblog/archive/v0.1.1.tar.gz"
  sha256 "14ac8029fc685417d419f28f2f04acb38ddfa269669b0c862d4ba6ca1fffb906"
  head "https://github.com/punchagan/metaweblog.git"

  def install
    (share/"emacs/site-lisp/metaweblog").install "metaweblog.el"
  end
end

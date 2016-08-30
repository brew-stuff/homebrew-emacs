require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Metaweblog < EmacsFormula
  desc "Emacs library to access metaweblog-based weblogs"
  homepage "https://github.com/punchagan/metaweblog"
  url "https://github.com/punchagan/metaweblog/archive/v0.1.1.tar.gz"
  sha256 "14ac8029fc685417d419f28f2f04acb38ddfa269669b0c862d4ba6ca1fffb906"
  head "https://github.com/punchagan/metaweblog.git"

  depends_on :emacs
  depends_on "xml-rpc-emacs"

  def install
    byte_compile "metaweblog.el"
    (share/"emacs/site-lisp/metaweblog").install "metaweblog.el",
                                                 "metaweblog.elc"
  end
end

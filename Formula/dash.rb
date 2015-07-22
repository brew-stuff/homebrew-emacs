require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Dash < EmacsFormula
  desc "A modern list library for Emacs"
  homepage "https://github.com/magnars/dash.el"
  url "https://github.com/magnars/dash.el/archive/2.11.0.tar.gz"
  sha256 "d888d34b9b86337c5740250f202e7f2efc3bf059b08a817a978bf54923673cde"
  head "https://github.com/magnars/dash.el.git"

  # the tests might not pass otherwise since it detects version 23 by
  # checking if $EMACS = "emacs23" which it probably won't be on OS X
  depends_on :emacs => "24.1"

  def install
    system "./run-tests.sh"
    system "./create-docs.sh"
    (share/"emacs/site-lisp/dash").install Dir["*.el"],
                                           Dir["*.elc"]
    doc.install "README.md", Dir["*.texi"]
    info.install "dash.info"
  end
end

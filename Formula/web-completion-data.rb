require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WebCompletionData < EmacsFormula
  desc "Completion data for ac-html and company-web"
  homepage "https://github.com/osv/web-completion-data"
  url "https://github.com/osv/web-completion-data/archive/v0.1.tar.gz"
  sha256 "ae74070f2612542af24684279a8ca191da1eead2c5ba5e1bcf7153d6c42ee995"
  head "https://github.com/osv/web-completion-data.git"

  bottle :unneeded

  def install
    (share/"emacs/site-lisp/web-completion-data").install Dir["*"]
  end
end

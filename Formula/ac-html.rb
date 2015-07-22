require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AcHtml < EmacsFormula
  desc "Autocompletion for HTML in Emacs"
  homepage "https://github.com/cheunghy/ac-html"
  url "https://github.com/cheunghy/ac-html/archive/v0.31.tar.gz"
  sha256 "759e2f0b91ea2babe41fd87fee079e897849966eb79b47e61bcadcb1ae9fbf42"
  head "https://github.com/cheunghy/ac-html.git"

  # is not tested on lower versions
  depends_on :emacs => "24.3"
  depends_on "cask"
  depends_on "dunn/emacs/auto-complete"
  depends_on "dunn/emacs/dash"
  depends_on "dunn/emacs/web-completion-data"

  def install
    # have (recursive) dependencies available for the tests
    %w[auto-complete dash web-completion-data popup].each do |dep|
      cp Dir["#{Formula["dunn/emacs/" + dep].share}/emacs/site-lisp/#{dep}/*.el"], buildpath
    end

    system "make"
    (share/"emacs/site-lisp/ac-html").install Dir["ac-*.el"]
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'ac-html)
    (add-hook 'html-mode-hook 'ac-html-enable)
    (add-to-list 'web-mode-ac-sources-alist
      '("html" . ( ac-source-html-attribute-value
                   ac-source-html-tag
                   ac-source-html-attribute)))
    EOS
  end
end

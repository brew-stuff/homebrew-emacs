require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Debbugs < EmacsFormula
  desc "Emacs library for accessing the GNU Bug Tracker"
  homepage "http://elpa.gnu.org/packages/debbugs.html"
  url "http://elpa.gnu.org/packages/debbugs-0.7.tar"
  sha256 "e2ec926e0f6dbdb3569542263f4c561c510e8893e4d1febe6211297547a76f5d"

  depends_on :emacs => "22.1"
  depends_on "dunn/emacs/soap-client-emacs" => "HEAD" if Emacs.version < 24.1

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/debbugs").install Dir["*.el"],
                                              Dir["*.elc"],
                                              "Debbugs.wsdl"
    doc.install "README"
    info.install "debbugs.info"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'debbugs-gnu)

    ;; If you have org-mode, you may want to add instead:

    (require 'debbugs-org)
    (autoload 'debbugs-org "debbugs-org" "" 'interactive)
    (autoload 'debbugs-org-search "debbugs-org" "" 'interactive)
    (autoload 'debbugs-org-bugs "debbugs-org" "" 'interactive)
  EOS
  end
end

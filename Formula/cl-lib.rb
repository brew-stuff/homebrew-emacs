require File.expand_path("../../Homebrew/emacs-formula", __FILE__)

class ClLib < EmacsFormula
  desc "Compatibility library for Emacs 24's cl-lib"
  homepage "http://elpa.gnu.org/packages/cl-lib.html"
  url "http://elpa.gnu.org/packages/cl-lib-0.5.el"
  sha256 "24a5c6ca95c3d702939f4e8d370eb9bbd496db86d4a022caefaba4753a738efc"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/cl-lib/cl-lib.el"

  depends_on :emacs

  def install
    mv "cl-lib-#{version}.el", "cl-lib.el" if build.stable?

    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/cl-lib").install Dir["*.el"],
                                             Dir["*.elc"]
  end

  if Emacs.version >= 24.3
    def caveats; <<-EOS.undent
      Warning: Emacs 24.3 and higher includes cl-lib

      Installing the compatibility library in parallel can have unexpected consequences.
      Make sure Emacs' native cl-lib appears before this one in your load-path.
    EOS
    end
  end
end

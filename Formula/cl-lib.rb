require File.expand_path("../../emacs", __FILE__)

class ClLib < Formula
  desc "Compatibility library for Emacs 24's cl-lib"
  homepage "http://elpa.gnu.org/packages/cl-lib.html"
  url "http://elpa.gnu.org/packages/cl-lib-0.5.el"
  sha256 "24a5c6ca95c3d702939f4e8d370eb9bbd496db86d4a022caefaba4753a738efc"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/cl-lib/cl-lib.el"

  def install
    mv "cl-lib-#{version}.el", "cl-lib.el" if build.stable?

    Emacs.compile Dir["*.el"]
    (share/"emacs/site-lisp/cl-lib").install Dir["*.el"],
                                             Dir["*.elc"]
  end

  if Emacs.version >= 24
    def caveats; <<-EOS.undent
      Warning: Emacs 24 and higher includes cl-lib

      Installing the compatibility library in parallel can have unexpected consequences.
      Make sure Emacs' native cl-lib appears before this one in your load-path.
    EOS
    end
  end
end

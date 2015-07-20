class ClLib < Formula
  desc "Compatibility library for Emacs 24's cl-lib"
  homepage "http://elpa.gnu.org/packages/cl-lib.html"
  url "http://elpa.gnu.org/packages/cl-lib-0.5.el"
  sha256 "24a5c6ca95c3d702939f4e8d370eb9bbd496db86d4a022caefaba4753a738efc"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/cl-lib/cl-lib.el"

  def install
    version_string = build.stable? ? "-#{version}" : ""
    (share/"emacs/site-lisp/cl-lib").install "cl-lib#{version_string}.el" => "cl-lib.el"
  end
end

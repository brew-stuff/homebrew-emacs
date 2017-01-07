require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ClLib < EmacsFormula
  desc "Compatibility library for Emacs 24's cl-lib"
  homepage "https://elpa.gnu.org/packages/cl-lib.html"
  url "https://elpa.gnu.org/packages/cl-lib-0.6.1.el"
  sha256 "3ec984402f531ad8b4fd58c9b5e62c56065d88b607caf8ec1de1c5c90d5f8703"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d6129d35b62520f5765a3673b744e4414694b8b31858ed7eeb9eff1f00cfde4" => :sierra
    sha256 "90a7cf3819e82ef479b8f6619b88fddfc1de7f3fb0a4fc7100a6f8f691b3b703" => :el_capitan
    sha256 "90a7cf3819e82ef479b8f6619b88fddfc1de7f3fb0a4fc7100a6f8f691b3b703" => :yosemite
  end

  depends_on :emacs => "21"

  def install
    mv "cl-lib-#{version}.el", "cl-lib.el"

    byte_compile "cl-lib.el"
    elisp.install "cl-lib.el", "cl-lib.elc"
  end

  if Emacs.version >= Version.create("24.3")
    def caveats; <<-EOS.undent
      Warning: Emacs 24.3 and higher includes cl-lib

      Installing the compatibility library in parallel can have unexpected consequences.
      Make sure Emacs' native cl-lib appears before this one in your load-path.
    EOS
    end
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "cl-lib")
      (print (cl-typep "homebrew" 'string))
    EOS
    assert_equal "t", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

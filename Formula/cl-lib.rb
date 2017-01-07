require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ClLib < EmacsFormula
  desc "Compatibility library for Emacs 24's cl-lib"
  homepage "https://elpa.gnu.org/packages/cl-lib.html"
  url "https://elpa.gnu.org/packages/cl-lib-0.6.1.el"
  sha256 "3ec984402f531ad8b4fd58c9b5e62c56065d88b607caf8ec1de1c5c90d5f8703"

  bottle do
    cellar :any_skip_relocation
    sha256 "066f128c9b851a894131e4ed26c150c4320ccd953e0fd7f53388b08a2d683fd5" => :sierra
    sha256 "b48a9625be157fadf2e11c64e1abc01c3e169ef87de924d5c31179b032858ef5" => :el_capitan
    sha256 "b48a9625be157fadf2e11c64e1abc01c3e169ef87de924d5c31179b032858ef5" => :yosemite
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

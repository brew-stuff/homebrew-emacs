require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ClLib < EmacsFormula
  desc "Compatibility library for Emacs 24's cl-lib"
  homepage "https://elpa.gnu.org/packages/cl-lib.html"
  url "https://elpa.gnu.org/packages/cl-lib-0.6.el"
  sha256 "d34f8b68414f3a48dec41c0728381c3e9254f7179776ddffe90944f7878865cb"

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

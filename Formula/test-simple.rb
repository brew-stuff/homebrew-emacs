require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TestSimple < EmacsFormula
  desc "Emacs unit test library"
  homepage "https://github.com/rocky/emacs-test-simple"
  url "https://elpa.gnu.org/packages/test-simple-1.3.0.el"
  sha256 "ffb3143dcd0b10e09c9620774ade295eab57189fa280046c5125e996980ca6f9"

  bottle :disable

  head do
    url "https://github.com/rocky/emacs-test-simple.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    if build.stable?
      mv "test-simple-#{version}.el", "test-simple.el"
      byte_compile "test-simple.el"
    else
      system "./autogen.sh"
      system "make", "check"
    end
    elisp.install "test-simple.el", "test-simple.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/test-simple")
      (load "test-simple")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

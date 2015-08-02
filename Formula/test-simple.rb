require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TestSimple < EmacsFormula
  desc "Emacs unit test library"
  homepage "https://github.com/rocky/emacs-test-simple"
  url "http://elpa.gnu.org/packages/test-simple-1.1.el"
  sha256 "9caa26d95aa6b368742843ea37da5166101d9f152eaaec8060c11a05f2341969"

  head do
    url "https://github.com/rocky/emacs-test-simple.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on :emacs => "23.1"

  def install
    if build.stable?
      mv "test-simple-#{version}.el", "test-simple.el"
      byte_compile "test-simple.el"
    else
      system "./autogen.sh"
      system "make", "check"
    end
    (share/"emacs/site-lisp/test-simple").install "test-simple.el",
                                                  "test-simple.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'test-simple)
  EOS
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

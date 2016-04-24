require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TestSimple < EmacsFormula
  desc "Emacs unit test library"
  homepage "https://github.com/rocky/emacs-test-simple"
  url "https://elpa.gnu.org/packages/test-simple-1.2.0.el"
  sha256 "6ba88eb6b2b18d1edba5d2b80f1eba7f09bf98f0c375fd358c53c41179c627c9"

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

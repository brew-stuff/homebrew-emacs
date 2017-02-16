require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class LoadRelative < EmacsFormula
  desc "Emacs Lisp functions for relative file load"
  homepage "https://github.com/rocky/emacs-load-relative"
  url "http://elpa.gnu.org/packages/load-relative-1.2.el"
  sha256 "3c66e3d491892b94833c0e9bca3a242aa70899af490e2f2608cb7e580055ae6e"

  head do
    url "https://github.com/rocky/emacs-load-relative.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "dunn/emacs/test-simple"
  end

  depends_on :emacs => "24.1"

  def install
    if build.stable?
      mv "load-relative-#{version}.el", "load-relative.el"
      byte_compile "load-relative.el"
    else
      system "./autogen.sh"
      cd "test" do
        system "make", "check-elget"
      end
      system "make"
    end
    (share/"emacs/site-lisp/load-relative").install "load-relative.el",
                                                    "load-relative.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'load-relative)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/load-relative")
      (load "load-relative")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

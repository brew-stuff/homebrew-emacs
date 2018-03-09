require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class LoadRelative < EmacsFormula
  desc "Emacs Lisp functions for relative file load"
  homepage "https://github.com/rocky/emacs-load-relative"
  url "https://elpa.gnu.org/packages/load-relative-1.3.el"
  sha256 "fab654764e67ebb5145e01e1e22455afa83b273d64ebea788aba49338858ddc1"

  head do
    url "https://github.com/rocky/emacs-load-relative.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "dunn/emacs/test-simple"
  end

  depends_on EmacsRequirement => "24.1"

  def install
    if build.stable?
      mv "load-relative-#{version}.el", "load-relative.el"
      byte_compile "load-relative.el"
    else
      system "./autogen.sh"
      system "make", "check"
      system "make"
    end
    elisp.install "load-relative.el", "load-relative.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/load-relative")
      (load "load-relative")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Slime < EmacsFormula
  desc "Emacs package for interactive programming in Lisp"
  homepage "http://common-lisp.net/project/slime/"
  url "https://github.com/slime/slime/archive/v2.16.tar.gz"
  sha256 "5390434c87d789f49c5976270c50078613b957a93aaa2ce962bc8d45247dafff"
  head "https://github.com/slime/slime.git"

  depends_on :emacs => "23.4"
  depends_on "sbcl"

  def install
    system "make"
    system "make", "compile-swank"
    system "make", "contrib-compile"
    elisp.install Dir["*.lisp"], Dir["*.el"], Dir["*.elc"],
                  "lib", "swank", "contrib"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "slime-autoloads")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

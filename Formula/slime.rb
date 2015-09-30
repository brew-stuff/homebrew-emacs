require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Slime < EmacsFormula
  desc "Emacs package for interactive programming in Lisp"
  homepage "http://common-lisp.net/project/slime/"
  url "https://github.com/slime/slime/archive/v2.15.tar.gz"
  sha256 "bad1851ce99b7f40b0593dc91842b261b526e0af797e660184159dda05355f50"
  head "https://github.com/slime/slime.git"

  depends_on :emacs => "23.4"
  depends_on "sbcl"

  def install
    system "make"
    system "make", "compile-swank"
    system "make", "contrib-compile"
    (share/"emacs/site-lisp/slime").install Dir["*.lisp"],
                                            Dir["*.el"], Dir["*.elc"],
                                            "lib", "swank", "contrib"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/slime")
      (load "slime-autoloads")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

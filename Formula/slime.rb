require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Slime < EmacsFormula
  desc "Emacs package for interactive programming in Lisp"
  homepage "http://common-lisp.net/project/slime/"
  url "https://github.com/slime/slime/archive/v2.14.tar.gz"
  sha256 "af55b95d94aacc89868df830cfc37e0f69d6949cfe26e15cc95b29df49388589"
  head "https://github.com/slime/slime.git"

  depends_on :emacs => "23.4"
  depends_on "sbcl"

  def install
    system "make" # "check"
    system "make", "compile-swank"
    system "make", "contrib-compile"
    (share/"emacs/site-lisp/slime").install Dir["*.lisp"],
                                            Dir["*.el"], Dir["*.elc"],
                                            "lib", "swank", "contrib"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'slime-autoloads)
    (setq inferior-lisp-program "#{Formula["sbcl"].opt_bin}/sbcl")
  EOS
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

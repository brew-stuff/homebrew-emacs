require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Js2Mode < EmacsFormula
  desc "Improved major mode for editing JavaScript in Emacs"
  homepage "https://github.com/mooz/js2-mode"
  url "https://github.com/mooz/js2-mode/archive/20150909.tar.gz"
  sha256 "0013a232f90a9cdf533b44c296875d0e4d6af373a8c411ee3864f149981955db"
  head "https://github.com/mooz/js2-mode.git"

  depends_on :emacs => "24.1"

  def install
    system "make", "BATCHFLAGS=-L . -batch -q --no-site-file"
    system "make", "test"
    (share/"emacs/site-lisp/js2-mode").install Dir["*.el"],
                                               Dir["*.elc"]
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'js2-mode)
    (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
    (add-to-list 'interpreter-mode-alist '("node" . js2-mode))
    (add-to-list 'interpreter-mode-alist '("iojs" . js2-mode))
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/js2-mode")
      (load "js2-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

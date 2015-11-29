require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WcheckMode < EmacsFormula
  desc "General-purpose text-checker interface for Emacs"
  homepage "https://github.com/tlikonen/wcheck-mode"
  url "https://github.com/tlikonen/wcheck-mode/archive/2015.11.29.tar.gz"
  sha256 "8292ce9a83b5af4be9d568c3f9fcc5be017da522b7c8b7197ab70c9ebb207f33"
  head "https://github.com/tlikonen/wcheck-mode.git"

  depends_on :emacs

  def install
    system "make", "elc"
    elisp.install "wcheck-mode.el", "wcheck-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/wcheck-mode")
      (load "wcheck-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

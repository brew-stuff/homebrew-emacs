require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Jumpc < EmacsFormula
  desc "Save and jump to previous cursor positions in Emacs"
  homepage "http://elpa.gnu.org/packages/jumpc.html"
  url "http://elpa.gnu.org/packages/jumpc-3.0.el"
  sha256 "ca548fdf39d8a3e5314e3a1633902ec9158ccb5bd20487a81a03ab5f077f0fee"

  depends_on :emacs

  def install
    mv "jumpc-#{version}.el", "jumpc.el"
    byte_compile "jumpc.el"
    (share/"emacs/site-lisp/jumpc").install "jumpc.el",
                                            "jumpc.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'jumpc)
    (jumpc)
    (jumpc-bind-vim-key)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/jumpc")
      (load "jumpc")
      (jumpc)
      (jumpc-bind-vim-key)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

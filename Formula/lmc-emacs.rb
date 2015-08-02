require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class LmcEmacs < EmacsFormula
  desc "Emacs lisp simulator for the Little Man Computer"
  homepage "http://elpa.gnu.org/packages/lmc.html"
  url "http://elpa.gnu.org/packages/lmc-1.3.el"
  sha256 "370096f5eb2c02c4f35baa8c143e5aecce2c493b367c700e83cb2df7f49cad68"

  depends_on :emacs

  def install
    mv "lmc-#{version}.el", "lmc.el"
    byte_compile "lmc.el"
    (share/"emacs/site-lisp/lmc").install "lmc.el",
                                          "lmc.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'lmc)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/lmc")
      (load "lmc")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

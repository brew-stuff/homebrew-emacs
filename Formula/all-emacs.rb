require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AllEmacs < EmacsFormula
  desc "Emacs package to edit all lines matching a given regexp"
  homepage "http://elpa.gnu.org/packages/all.html"
  url "http://elpa.gnu.org/packages/all-1.0.el"
  sha256 "23c200460cb8ebcbc03e781562277e550b8c6bb075593de0d70840dbc165049e"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/all/all.el"

  depends_on EmacsRequirement

  def install
    mv "all-#{version}.el", "all.el" if build.stable?
    byte_compile "all.el"
    (share/"emacs/site-lisp/all").install "all.el", "all.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'all)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/all")
      (load "all")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

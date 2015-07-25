require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ScrollRestore < EmacsFormula
  desc "Emacs minor mode to restore point after scrolling"
  homepage "http://elpa.gnu.org/packages/scroll-restore.html"
  url "http://elpa.gnu.org/packages/scroll-restore-1.0.el"
  sha256 "164e232bcdf72fdd0fae9c5b742888c4f863c9a168ef67da66f5d759e9d7a540"

  depends_on :emacs

  def install
    mv "scroll-restore-#{version}.el", "scroll-restore.el"
    byte_compile "scroll-restore.el"
    (share/"emacs/site-lisp/scroll-restore").install "scroll-restore.el",
                                                     "scroll-restore.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'scroll-restore)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "scroll-restore")
      (scroll-restore-remove)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

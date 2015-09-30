require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Evil < EmacsFormula
  desc "Extensible vi layer for Emacs"
  homepage "https://bitbucket.org/lyro/evil"
  url "https://bitbucket.org/lyro/evil/get/1.2.5.tar.bz2"
  sha256 "c6512390b5b0656cbab5a3c4e4f56e07ee9a9a2d17ef9df969ed41119a1e8c6e"
  head "https://bitbucket.org/lyro/evil", :using => :hg

  depends_on :emacs
  depends_on "homebrew/emacs/undo-tree"

  def install
    system "make"
    (share/"emacs/site-lisp/evil").install Dir["*.el"], Dir["*.elc"]
    (share/"emacs/site-lisp/evil").install "lib/goto-chg.el"

    system "make", "info"
    info.install "doc/evil.info"
    doc.install "doc/evil.pdf"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/evil")
      (load "evil")
      (evil-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

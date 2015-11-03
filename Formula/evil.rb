require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Evil < EmacsFormula
  desc "Extensible vi layer for Emacs"
  homepage "https://bitbucket.org/lyro/evil"
  url "https://bitbucket.org/lyro/evil/get/1.2.7.tar.bz2"
  sha256 "df3a321b866e75d056690cd5104dfee1652f0ae2c268e655859e2a5967727503"
  head "https://bitbucket.org/lyro/evil", :using => :hg

  depends_on :emacs
  depends_on "homebrew/emacs/undo-tree"

  def install
    system "make"
    elisp.install Dir["*.el"], Dir["*.elc"], "lib/goto-chg.el"

    system "make", "info"
    info.install "doc/evil.info"
    doc.install "doc/evil.pdf"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "evil")
      (evil-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

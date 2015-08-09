require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Evil < EmacsFormula
  desc "Extensible vi layer for Emacs"
  homepage "https://bitbucket.org/lyro/evil"
  url "https://bitbucket.org/lyro/evil/get/1.2.2.tar.bz2"
  sha256 "fc43392e2178b54528f44147fc2b0f905b9dfdfe5b1860e46da428b3ac9ba444"
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

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'evil)
    (evil-mode 1)
  EOS
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

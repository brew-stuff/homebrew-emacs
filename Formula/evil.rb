require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Evil < EmacsFormula
  desc "Extensible vi layer for Emacs"
  homepage "https://github.com/emacs-evil/evil"
  url "https://github.com/emacs-evil/evil/archive/1.2.12.tar.gz"
  sha256 "035d2257e39819dc769ee069ef163dc22edfa40eb81842967539c2111475f7b8"
  head "https://github.com/emacs-evil/evil.git"

  bottle :disable

  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/undo-tree"

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

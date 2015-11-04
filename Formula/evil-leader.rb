require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class EvilLeader < EmacsFormula
  desc "<leader> key for evil."
  homepage "https://github.com/cofi/evil-leader"
  url "https://github.com/cofi/evil-leader/archive/0.4.3.tar.gz"
  sha256 "1e650e2171b7c79df10ece5380e239cf0eac671acb2f3a0db8e75e14fca659ed"
  head "https://github.com/cofi/evil-leader.git"

  depends_on :emacs
  depends_on "evil"

  def install
    byte_compile "evil-leader.el"
    elisp.install "evil-leader.el", "evil-leader.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'evil-leader)
    (global-evil-leader-mode)
  EOS
  end

  test do
    evil = Formula["evil"]
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{evil.opt_elisp}")
      (add-to-list 'load-path "#{elisp}")
      (load "evil-leader")
      (global-evil-leader-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

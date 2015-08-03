require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class EmojiCheatSheetPlus < EmacsFormula
  desc "Browse and insert emoji in Emacs"
  homepage "https://github.com/syl20bnr/emacs-emoji-cheat-sheet-plus"
  url "https://github.com/syl20bnr/emacs-emoji-cheat-sheet-plus/archive/v1.2.1.tar.gz"
  sha256 "7f8592a2a54e8fd58689f8f6a6d118b9511e48ce56fa84f294fa6623333c7d5a"
  head "https://github.com/syl20bnr/emacs-emoji-cheat-sheet-plus.git"

  # due to helm
  depends_on :emacs => "24.3"
  depends_on "homebrew/emacs/helm"

  def install
    byte_compile "emoji-cheat-sheet-plus.el"
    doc.install "README.md", "LICENSE"
    (share/"emacs/site-lisp/emoji-cheat-sheet-plus").install Dir["*"]
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'emoji-cheat-sheet-plus)
    (global-set-key (kbd "C-c e") 'emoji-cheat-sheet-plus-insert)))
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/emoji-cheat-sheet-plus")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/helm"].share}/emacs/site-lisp/helm")
      (load "helm")
      (load "emoji-cheat-sheet-plus")
      (emoji-cheat-sheet-plus--create-cache)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

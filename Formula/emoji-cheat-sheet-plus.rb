require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class EmojiCheatSheetPlus < EmacsFormula
  desc "Browse and insert emoji in Emacs"
  homepage "https://github.com/syl20bnr/emacs-emoji-cheat-sheet-plus"
  url "https://github.com/syl20bnr/emacs-emoji-cheat-sheet-plus/archive/v1.2.1.tar.gz"
  sha256 "7f8592a2a54e8fd58689f8f6a6d118b9511e48ce56fa84f294fa6623333c7d5a"
  head "https://github.com/syl20bnr/emacs-emoji-cheat-sheet-plus.git"

  depends_on :emacs => ["24.3", "with-cocoa"]
  depends_on "homebrew/emacs/helm"

  def install
    byte_compile "emoji-cheat-sheet-plus.el"
    elisp.install "emoji-cheat-sheet", Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/helm"].opt_elisp}")
      (load "helm")
      (load "emoji-cheat-sheet-plus")
      (emoji-cheat-sheet-plus--create-cache)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

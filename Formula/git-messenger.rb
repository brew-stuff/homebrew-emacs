require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class GitMessenger < EmacsFormula
  desc "Show commit info for individual lines in Emacs"
  homepage "https://github.com/syohex/emacs-git-messenger"
  url "https://github.com/syohex/emacs-git-messenger/archive/0.16.tar.gz"
  sha256 "a9065dfeee4f6594fe510aa933ebcd64e11d3cab1a2571edb1d4c5c8c5981969"
  head "https://github.com/syohex/emacs-git-messenger.git"

  depends_on :emacs
  depends_on "homebrew/emacs/popup"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile "git-messenger.el"
    (share/"emacs/site-lisp/git-messenger").install "git-messenger.el",
                                                    "git-messenger.elc"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'git-messenger)
    (setq git-messenger:show-detail t)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/git-messenger")
      (add-to-list 'load-path "#{Formula["popup"].share}/emacs/site-lisp/popup")
      (load "git-messenger")
      (git-messenger:execute-command 'git '("init") t)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
    (testpath/".git").exist?
  end
end

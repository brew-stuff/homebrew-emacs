require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class GitMessenger < EmacsFormula
  desc "Show commit info for individual lines in Emacs"
  homepage "https://github.com/syohex/emacs-git-messenger"
  url "https://github.com/syohex/emacs-git-messenger/archive/0.18.tar.gz"
  sha256 "e9daa597be69a11afb974986c5f2de67c62eaf606cb176ac33a473f04c9cb89e"
  head "https://github.com/syohex/emacs-git-messenger.git"

  depends_on :emacs
  depends_on "homebrew/emacs/popup"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile "git-messenger.el"
    elisp.install "git-messenger.el", "git-messenger.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/git-messenger")
      (add-to-list 'load-path "#{Formula["popup"].opt_share}/emacs/site-lisp/popup")
      (load "git-messenger")
      (git-messenger:execute-command 'git '("init") t)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
    assert File.exist?(".git"), "Failed to init!"
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class GitModes < EmacsFormula
  desc "Emacs major modes for git config, attributes, and ignore"
  homepage "https://github.com/magit/git-modes"
  url "https://github.com/magit/git-modes/archive/1.2.1.tar.gz"
  sha256 "17d4dfc89331a8d52be5c3409098ff9cbc9f6c22a44310cfe11e78045bf31c21"
  head "https://github.com/magit/git-modes.git"

  depends_on :emacs

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "git-modes")
      (gitattributes-mode-help)
      (gitconfig-indentation-string)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

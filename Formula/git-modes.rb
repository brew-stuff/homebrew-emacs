class GitModes < Formula
  desc "Emacs major modes for git config, attributes, and ignore"
  homepage "https://github.com/magit/git-modes"
  url "https://github.com/magit/git-modes/archive/1.2.0.tar.gz"
  sha256 "13e2584013e6aab940b8531e4eda4a4ef4da2efe4eee4a87277109b9663cbb25"
  head "https://github.com/magit/git-modes.git"

  # min version unclear but required for compiling
  depends_on :emacs => "22.1"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'gitattributes-mode)
    (require 'gitconfig-mode)
    (require 'gitignore-mode)
    (add-to-list 'auto-mode-alist '("^\\.gitattributes$" . gitattributes-mode))
    (add-to-list 'auto-mode-alist '("^\\.gitconfig$" . gitconfig-mode))
    (add-to-list 'auto-mode-alist '("^\\.gitignore$" . gitignore-mode))
    (add-to-list 'auto-mode-alist '("\\.git\/info\/attributes$" . gitignore-mode))
    (add-to-list 'auto-mode-alist '("\\.git\/config$" . gitignore-mode))
    (add-to-list 'auto-mode-alist '("\\.git\/info\/exclude$" . gitignore-mode))
    EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/git-modes")
      (load "gitattributes-mode")
      (load "gitconfig-mode")
      (load "gitignore-mode")
      (gitattributes-mode-help)
      (gitconfig-indentation-string)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

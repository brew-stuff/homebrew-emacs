require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class GitModes < EmacsFormula
  desc "Emacs major modes for git config, attributes, and ignore"
  homepage "https://github.com/magit/git-modes"
  url "https://github.com/magit/git-modes/archive/1.2.4.tar.gz"
  sha256 "149d91b52ca222e360a9d22bdb6898243e8a3650580846e9ee927a2b81abb977"
  head "https://github.com/magit/git-modes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de1e3c8b8bd03c6eb34df8562bf236f1ca63a5b029cdd12a4ec9e15002a172d6" => :sierra
    sha256 "35c84d898e53906342f652e9d929ff6f9e01a91455a6ae7e744e648444414efc" => :el_capitan
    sha256 "35c84d898e53906342f652e9d929ff6f9e01a91455a6ae7e744e648444414efc" => :yosemite
  end

  depends_on EmacsRequirement

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "git-modes")
      (gitattributes-mode-help)
      (gitconfig-indentation-string)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

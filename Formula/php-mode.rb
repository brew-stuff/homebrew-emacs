class PhpMode < Formula
  desc "Major mode for editing PHP files"
  homepage "https://github.com/ejmr/php-mode"
  url "https://github.com/ejmr/php-mode/archive/v1.17.0.tar.gz"
  sha256 "4393e452e7ade8b7479a3b942b985a9495f6a961b443308718756038d21c231d"
  head "https://github.com/ejmr/php-mode.git"

  depends_on :emacs => "24.1"

  def install
    system "make", "test"
    (share/"emacs/site-lisp/php-mode").install Dir["*.el"],
                                               Dir["*.elc"]
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

      (require 'php-mode)
      (add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
    EOS
  end
end

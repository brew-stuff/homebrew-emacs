require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AnzuMode < EmacsFormula
  desc "Emacs minor mode for numbering search results"
  homepage "https://github.com/syohex/emacs-anzu"
  url "https://github.com/syohex/emacs-anzu/archive/0.55.tar.gz"
  sha256 "090f0cb80108d23d865a0ad9c1a15e71333bda674aa2e45dbf6a7d0086dc6ddf"
  head "https://github.com/syohex/emacs-anzu.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile "anzu.el"
    (share/"emacs/site-lisp/anzu").install "anzu.el", "anzu.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'anzu)
    (global-anzu-mode +1)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/anzu")
      (load "anzu")
      (anzu-mode +1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

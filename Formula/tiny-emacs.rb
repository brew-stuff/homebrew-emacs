require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TinyEmacs < EmacsFormula
  desc "Emacs package for generating linear ranges"
  homepage "https://github.com/abo-abo/tiny"
  url "http://elpa.gnu.org/packages/tiny-0.1.tar"
  sha256 "38e09e8e5f09073c1770508968692312c114a66ab8f3728a9aa4da277f8b3e12"
  head "https://github.com/abo-abo/tiny.git"

  depends_on :emacs
  depends_on "cask"

  def install
    system "make", "test"
    system "make", "compile"
    (share/"emacs/site-lisp/tiny").install Dir["*.el"], Dir["*.elc"]
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'tiny)
    (global-set-key (kbd "C-;") 'tiny-expand)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "tiny")
      (print (tiny-tokenize "+x2"))
    EOS
    assert_equal "\"(+ x 2)\"", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

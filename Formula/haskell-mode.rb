require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class HaskellMode < EmacsFormula
  desc "Emacs major mode for Haskell"
  homepage "https://github.com/haskell/haskell-mode"
  url "https://github.com/haskell/haskell-mode/archive/v13.14.2.tar.gz"
  sha256 "5b2577b60be74147af09d90d93bacfac295ad881c8e490761322ac8da417accf"
  head "https://github.com/haskell/haskell-mode.git"

  option "with-html", "Build HTML documentation"

  depends_on :emacs => "23.1"
  depends_on "texinfo" if build.with? "html"

  def install
    system "make"
    system "make", "check"
    (share/"emacs/site-lisp/haskell-mode").install Dir["*.el"],
                                                   Dir["*.elc"]
    doc.install "README.md"
    info.install Dir["*.info"]

    if build.with? "html"
      system "make", "doc/html"
      doc.install "doc/html"
    end
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'haskell-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/haskell-mode")
      (load "haskell-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

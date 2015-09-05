require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class HomebrewMode < EmacsFormula
  desc "Emacs minor mode for editing Homebrew formulae"
  homepage "https://github.com/dunn/homebrew-mode"
  url "https://github.com/dunn/homebrew-mode/archive/1.2.1.tar.gz"
  sha256 "f6b132a451c9ca71b6e630d6d4431ea958753a8e3913f02a96b1f9cb18cd9766"
  head "https://github.com/dunn/homebrew-mode.git"

  depends_on :emacs => "24.4"
  depends_on "homebrew/emacs/dash"
  depends_on "homebrew/emacs/inf-ruby"

  def install
    system "make", "test"
    system "make", "install", "prefix=#{prefix}"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'homebrew-mode)
    (global-homebrew-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/homebrew-mode")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/inf-ruby"].share}/emacs/site-lisp/inf-ruby")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash"].share}/emacs/site-lisp/dash")

      (load "homebrew-mode")
      (print homebrew-mode-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

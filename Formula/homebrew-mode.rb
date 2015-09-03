require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class HomebrewMode < EmacsFormula
  desc "Emacs minor mode for editing Homebrew formulae"
  homepage "https://github.com/dunn/homebrew-mode"
  url "https://github.com/dunn/homebrew-mode/archive/1.1.1.tar.gz"
  sha256 "2c4014418c6f5e07c9748d13466f0004e89f8b77e17e030a55d52ce678a537c6"
  head "https://github.com/dunn/homebrew-mode.git"

  depends_on :emacs
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

      (load "homebrew-mode")
      (print homebrew-mode-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

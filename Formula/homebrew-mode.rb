require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class HomebrewMode < EmacsFormula
  desc "Emacs minor mode for editing Homebrew formulae"
  homepage "https://github.com/dunn/homebrew-mode"
  url "https://github.com/dunn/homebrew-mode/archive/0.4.1.tar.gz"
  sha256 "e7430ccf724b61280189d58446801ea49b96c684982f95e7002e64c43ac05484"
  head "https://github.com/dunn/homebrew-mode.git"

  depends_on :emacs

  def install
    system "make", "test"
    system "make", "install", "prefix=#{prefix}"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'homebrew-mode)
    (homebrew-mode-default-hooks)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/homebrew-mode")
      (load "homebrew-mode")
      (print homebrew-mode-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

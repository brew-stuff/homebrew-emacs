require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class HomebrewMode < EmacsFormula
  desc "Emacs minor mode for editing Homebrew formulae"
  homepage "https://github.com/dunn/homebrew-mode"
  url "https://github.com/dunn/homebrew-mode/archive/1.0.0.tar.gz"
  sha256 "570d3d45bd751529efa97029231475fb3af7871aebb1d0b2b6a2fb6a68f03612"
  head "https://github.com/dunn/homebrew-mode.git"

  depends_on :emacs

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
      (load "homebrew-mode")
      (print homebrew-mode-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

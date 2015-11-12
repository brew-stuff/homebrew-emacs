require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class RainbowDelimiters < EmacsFormula
  desc "Color delimiters by depth in Emacs"
  homepage "https://github.com/Fanael/rainbow-delimiters"
  url "https://github.com/Fanael/rainbow-delimiters/archive/2.1.1.tar.gz"
  sha256 "6fe03f2e1b6c8ea317a82caeb8daa30910155208b0b70f980c66f01700908f18"
  head "https://github.com/Fanael/rainbow-delimiters.git"

  depends_on :emacs

  def install
    ert_run_tests "rainbow-delimiters-test.el"

    byte_compile "rainbow-delimiters.el"
    elisp.install "rainbow-delimiters.el", "rainbow-delimiters.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "rainbow-delimiters")
      (rainbow-delimiters-mode-enable)
      (rainbow-delimiters-mode-disable)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

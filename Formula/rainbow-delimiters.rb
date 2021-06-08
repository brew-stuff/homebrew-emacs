require File.expand_path("../Homebrew/emacs_formula", __dir__)

class RainbowDelimiters < EmacsFormula
  desc "Color delimiters by depth in Emacs"
  homepage "https://github.com/Fanael/rainbow-delimiters"
  url "https://github.com/Fanael/rainbow-delimiters/archive/2.1.3.tar.gz"
  sha256 "39a5aa2f5b6fc5ac7c97362442459d8f012ea5536c6720929666611dc995d974"
  head "https://github.com/Fanael/rainbow-delimiters.git"

  depends_on EmacsRequirement

  def install
    ert_run_tests "rainbow-delimiters-test.el"

    byte_compile "rainbow-delimiters.el"
    elisp.install "rainbow-delimiters.el", "rainbow-delimiters.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "rainbow-delimiters")
      (rainbow-delimiters-mode-enable)
      (rainbow-delimiters-mode-disable)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

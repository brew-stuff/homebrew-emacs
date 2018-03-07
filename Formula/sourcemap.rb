require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Sourcemap < EmacsFormula
  desc "Sourcemap parser for Emacs"
  homepage "https://github.com/syohex/emacs-sourcemap"
  url "https://github.com/syohex/emacs-sourcemap/archive/0.03.tar.gz"
  sha256 "a61a8d4bad13b4022912717277db9d072c80346c9d20dbf7a13e8ace062dad2e"
  head "https://github.com/syohex/emacs-sourcemap.git"

  bottle :disable

  depends_on EmacsRequirement => "24.3"

  def install
    ert_run_tests "test/test-sourcemap.el"

    byte_compile "sourcemap.el"
    elisp.install "sourcemap.el", "sourcemap.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "sourcemap")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Javaimp < EmacsFormula
  desc "Emacs functions for Java imports in Maven projects"
  homepage "https://elpa.gnu.org/packages/javaimp.html"
  url "https://elpa.gnu.org/packages/javaimp-0.6.tar"
  sha256 "ce09593f934c370c41e99f95d4aeaab1581414213e7d6af09952e7653a64b304"

  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/seq" if Emacs.version < Version.create("25")

  def install
    ert_run_tests "javaimp-tests.el"
    byte_compile "javaimp.el"
    elisp.install "javaimp.el", "javaimp.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/seq"].opt_elisp}")
      (load "javaimp")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

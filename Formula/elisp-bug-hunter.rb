require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ElispBugHunter < EmacsFormula
  desc "Emacs library for debugging configuration files"
  homepage "https://github.com/Malabarba/elisp-bug-hunter"
  url "https://github.com/Malabarba/elisp-bug-hunter/archive/1.1.tar.gz"
  sha256 "ddc1704f8c5f84f270138c85e710ad81e7d3b1424719bdcf5c3e95a250560ce8"
  head "https://github.com/Malabarba/elisp-bug-hunter.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/seq" if Emacs.version < 25
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    ert_run_tests "bug-hunter-test.el"

    byte_compile "bug-hunter.el"
    elisp.install "bug-hunter.el", "bug-hunter.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/seq"].opt_elisp}")
      (load "bug-hunter")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

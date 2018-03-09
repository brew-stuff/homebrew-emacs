require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ElispBugHunter < EmacsFormula
  desc "Emacs library for debugging configuration files"
  homepage "https://github.com/Malabarba/elisp-bug-hunter"
  url "https://elpa.gnu.org/packages/bug-hunter-1.3.1.el"
  sha256 "5d009cb82b8083c681c17446a318e9fe19ac686fb7cede3748999020abd5f476"
  head "https://github.com/Malabarba/elisp-bug-hunter.git"

  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/seq" if Emacs.version < Version.create("25")
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    if build.stable?
      mv "bug-hunter-#{version}.el", "bug-hunter.el"
    else
      ert_run_tests "bug-hunter-test.el"
    end
    byte_compile "bug-hunter.el"
    elisp.install "bug-hunter.el", "bug-hunter.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/seq"].opt_elisp}")
      (load "bug-hunter")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

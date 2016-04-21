require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ElispBugHunter < EmacsFormula
  desc "Emacs library for debugging configuration files"
  homepage "https://github.com/Malabarba/elisp-bug-hunter"
  url "https://elpa.gnu.org/packages/bug-hunter-1.3.el"
  sha256 "bdcc6706986e14045849c6ae4cf2587f06a4c22c787a4a8ff4837241ab4d2dc8"
  head "https://github.com/Malabarba/elisp-bug-hunter.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/seq" if Emacs.version < 25
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

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
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/seq"].opt_elisp}")
      (load "bug-hunter")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

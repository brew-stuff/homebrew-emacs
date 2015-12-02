require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ElispBugHunter < EmacsFormula
  desc "Emacs library for debugging configuration files"
  homepage "https://github.com/Malabarba/elisp-bug-hunter"
  url "http://elpa.gnu.org/packages/bug-hunter-1.0.1.el"
  sha256 "2d797e2a064e990af05d1dcf71a208920d79850162f656c40c2c012f48791730"
  head "https://github.com/Malabarba/elisp-bug-hunter.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/seq"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    mv "bug-hunter-#{version}.el", "bug-hunter.el" if build.stable?
    ert_run_tests "bug-hunter-test.el" if build.head?

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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ElispBugHunter < EmacsFormula
  desc "Emacs library for debugging configuration files"
  homepage "https://github.com/Malabarba/elisp-bug-hunter"
  url "http://elpa.gnu.org/packages/bug-hunter-1.0.el"
  sha256 "10cd9035611c0d29a2104a7bbe65f0d8ef1c523190c98d745eaa36dd48c91e6d"
  head "https://github.com/Malabarba/elisp-bug-hunter.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/seq"

  def install
    mv "bug-hunter-#{version}.el", "bug-hunter.el" if build.stable?
    ert_run_tests "bug-hunter-test.el" if build.head?

    byte_compile "bug-hunter.el"
    (share/"emacs/site-lisp/bug-hunter").install "bug-hunter.el",
                                                 "bug-hunter.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/bug-hunter")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/seq"].opt_share}/emacs/site-lisp/seq")
      (load "bug-hunter")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

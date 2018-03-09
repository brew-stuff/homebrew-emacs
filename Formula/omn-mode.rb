require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class OmnMode < EmacsFormula
  desc "Emacs major mode for the OWL Manchester Notation"
  homepage "https://elpa.gnu.org/packages/omn-mode.html"
  url "https://elpa.gnu.org/packages/omn-mode-1.2.el"
  sha256 "829c291ddd7f3208e5142cce450e93d5ac808f5d919e9f7011c6b2b614aef45c"

  depends_on EmacsRequirement

  def install
    mv "omn-mode-#{version}.el", "omn-mode.el"
    byte_compile "omn-mode.el"
    elisp.install "omn-mode.el", "omn-mode.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/omn-mode")
      (load "omn-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

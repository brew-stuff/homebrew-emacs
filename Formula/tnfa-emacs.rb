require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TnfaEmacs < EmacsFormula
  desc "Tagged non-deterministic finite-state automata"
  homepage "http://www.dr-qubit.org/emacs_data-structures.html"
  url "https://elpa.gnu.org/packages/tNFA-0.1.1.el"
  sha256 "ba691bbbed5328939ca3a562a9231640502dd657f99c2f68295338f428bac406"

  bottle :disable

  depends_on EmacsRequirement
  depends_on "dunn/emacs/queue-emacs"

  def install
    mv "tNFA-#{version}.el", "tNFA.el"
    byte_compile "tNFA.el"
    elisp.install "tNFA.el", "tNFA.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["queue-emacs"].opt_elisp}")
      (load "tNFA")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

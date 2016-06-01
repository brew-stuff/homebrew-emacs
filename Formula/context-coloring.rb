require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ContextColoring < EmacsFormula
  desc "Emacs mode to color JS and Elisp code by scope"
  homepage "https://github.com/jacksonrayhamilton/context-coloring"
  url "https://github.com/jacksonrayhamilton/context-coloring/archive/v8.0.1.tar.gz"
  sha256 "06fc76c24bc738b595d2fff1c1fd41e1015a248d6bc9cdee5637b83d27d393b5"
  head "https://github.com/jacksonrayhamilton/context-coloring.git"

  depends_on :emacs => "24.3"
  depends_on "homebrew/emacs/js2-mode"
  depends_on "homebrew/emacs/undercover" => :build

  def install
    ert_run_tests Dir["test/*.el"]
    byte_compile Dir["*.el"]
    elisp.install "context-coloring.el", "context-coloring.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["js2-mode"].opt_elisp}")
      (load "context-coloring")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

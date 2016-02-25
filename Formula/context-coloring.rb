require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ContextColoring < EmacsFormula
  desc "Emacs mode to color JS and Elisp code by scope"
  homepage "https://github.com/jacksonrayhamilton/context-coloring"
  url "https://github.com/jacksonrayhamilton/context-coloring/archive/v7.2.1.tar.gz"
  sha256 "81265c908086cfd429b11e7a92f009dd77fa49c4437485c1c7e4ee8c333010ad"
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

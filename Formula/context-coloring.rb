require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ContextColoring < EmacsFormula
  desc "Emacs mode to color JS and Elisp code by scope"
  homepage "https://github.com/jacksonrayhamilton/context-coloring"
  url "https://github.com/jacksonrayhamilton/context-coloring/archive/v8.1.0.tar.gz"
  sha256 "cc19110feca916f9be3cd697ac1e17b7a067f0d707289634033540328d550797"
  head "https://github.com/jacksonrayhamilton/context-coloring.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0428ce4dca6692f59da3f041a7065e79f6b84cdf40533456dca62df05536df62" => :sierra
    sha256 "e52354f9efd6366f213c87d8fba5f3086ec577665c011a2f9b0b06b843ebae99" => :el_capitan
    sha256 "e52354f9efd6366f213c87d8fba5f3086ec577665c011a2f9b0b06b843ebae99" => :yosemite
  end

  depends_on :emacs => "24.3"
  depends_on "homebrew/emacs/js2-mode"

  def install
    ert_run_tests "context-coloring-test.el"

    byte_compile "context-coloring-emacs-lisp.el",
                 "context-coloring-javascript.el",
                 "context-coloring.el"

    elisp.install "context-coloring-emacs-lisp.el", "context-coloring-emacs-lisp.elc",
                  "context-coloring-javascript.el", "context-coloring-javascript.elc",
                  "context-coloring.el", "context-coloring.elc"
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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Jade < EmacsFormula
  desc "JavaScript Awesome Development Environment"
  homepage "https://github.com/NicolasPetton/jade"
  url "https://github.com/NicolasPetton/jade/archive/0.28.tar.gz"
  sha256 "c8588ad47b0f9badc158cffb3cc77ef8b1dbe07ab4323bc3e8c29e0aa063dc2c"
  head "https://github.com/NicolasPetton/jade.git"

  bottle :disable

  depends_on :emacs => "25.1"
  depends_on "dunn/emacs/company-mode"
  depends_on "dunn/emacs/js2-mode"
  depends_on "dunn/emacs/seq"
  depends_on "dunn/emacs/websocket-emacs"

  def install
    ert_run_tests "test/jade-interaction-test.el"

    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/company-mode"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/js2-mode"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/seq"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/websocket-emacs"].opt_elisp}")
      (load "jade")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

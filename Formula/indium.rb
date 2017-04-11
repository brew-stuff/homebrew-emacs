require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Indium < EmacsFormula
  desc "JavaScript development environment for Emacs"
  homepage "https://github.com/NicolasPetton/Indium"
  url "https://github.com/NicolasPetton/Indium/archive/0.4.0.tar.gz"
  sha256 "1b2890afa3e2d12999d513b8279b0eeb6b5f99a409d1bb62dd4dd3d4e9466637"
  head "https://github.com/NicolasPetton/Indium.git"

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
      (load "indium")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

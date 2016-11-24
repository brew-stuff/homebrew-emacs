require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Jade < EmacsFormula
  desc "JavaScript Awesome Development Environment"
  homepage "https://github.com/NicolasPetton/jade"
  url "https://github.com/NicolasPetton/jade/archive/0.26.tar.gz"
  sha256 "c0a996e0f5c25145ee17abb418277d866386a84c2d48ecbcd96ecda2cc6f28cf"
  head "https://github.com/NicolasPetton/jade.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b20073a2b04b7cc3d4791506c40d8dc4e62673451c0ba24531b0f27ce79f9c1" => :sierra
    sha256 "3b20073a2b04b7cc3d4791506c40d8dc4e62673451c0ba24531b0f27ce79f9c1" => :el_capitan
    sha256 "3b20073a2b04b7cc3d4791506c40d8dc4e62673451c0ba24531b0f27ce79f9c1" => :yosemite
  end

  depends_on :emacs => "25.1"
  depends_on "homebrew/emacs/company-mode"
  depends_on "homebrew/emacs/js2-mode"
  depends_on "homebrew/emacs/seq"
  depends_on "homebrew/emacs/websocket-emacs"

  def install
    ert_run_tests "test/jade-interaction-test.el"

    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/company-mode"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/js2-mode"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/seq"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/websocket-emacs"].opt_elisp}")
      (load "jade")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

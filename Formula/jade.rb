require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Jade < EmacsFormula
  desc "JavaScript Awesome Development Environment"
  homepage "https://github.com/NicolasPetton/jade"
  url "https://github.com/NicolasPetton/jade/archive/0.23.tar.gz"
  sha256 "4028cc589f57d0c456a2a3fe1e65be068b200e1f479c609445bc15493da8098c"
  head "https://github.com/NicolasPetton/jade.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84e9e0ab2b85c185e6ed632f9851965879f55053b6764cd135f41b0d86749117" => :sierra
    sha256 "84e9e0ab2b85c185e6ed632f9851965879f55053b6764cd135f41b0d86749117" => :el_capitan
    sha256 "84e9e0ab2b85c185e6ed632f9851965879f55053b6764cd135f41b0d86749117" => :yosemite
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

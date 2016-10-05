require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Jade < EmacsFormula
  desc "JavaScript Awesome Development Environment"
  homepage "https://github.com/NicolasPetton/jade"
  url "https://github.com/NicolasPetton/jade/archive/0.22.tar.gz"
  sha256 "8e693fde295795c543e6373b43dab9ba6139abfa559e38cd5672d73ff4a3efc2"
  head "https://github.com/NicolasPetton/jade.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f73022a883f2c1b4f3165a26269dde452da02f9e8ecc87d1dbc07b3ee81e954" => :sierra
    sha256 "9f73022a883f2c1b4f3165a26269dde452da02f9e8ecc87d1dbc07b3ee81e954" => :el_capitan
    sha256 "9f73022a883f2c1b4f3165a26269dde452da02f9e8ecc87d1dbc07b3ee81e954" => :yosemite
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

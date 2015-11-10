require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CommanderEmacs < EmacsFormula
  desc "Emacs command-line parser"
  homepage "https://github.com/rejeep/commander.el"
  url "https://github.com/rejeep/commander.el/archive/v0.7.0.tar.gz"
  sha256 "5eb0f7f016b484ffc91bcd54ced1b0455667e5ee93077a92eafc9d5f4214daa4"
  head "https://github.com/rejeep/commander.el.git"

  depends_on :emacs
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/f"
  depends_on "homebrew/emacs/s"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile "commander.el"
    elisp.install "commander.el", "commander.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/f"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/s"].opt_elisp}")
      (load "commander")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../Homebrew/emacs_formula", __dir__)

class WhichKey < EmacsFormula
  desc "Emacs package for displaying available keybindings"
  homepage "https://github.com/justbur/emacs-which-key"
  url "https://github.com/justbur/emacs-which-key/archive/v3.1.0.tar.gz"
  sha256 "383c02189cca4e734f84d6039ebd6d64f7ffd0021146c286ab485e8bafdeb540"
  head "https://github.com/justbur/emacs-which-key.git"

  bottle :disable

  depends_on EmacsRequirement => "24.3"

  def install
    ert_run_tests "which-key-tests.el"
    byte_compile "which-key.el"
    elisp.install "which-key.el", "which-key.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "which-key")
      (which-key-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

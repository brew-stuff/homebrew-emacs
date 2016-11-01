require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WhichKey < EmacsFormula
  desc "Emacs package for displaying available keybindings"
  homepage "https://github.com/justbur/emacs-which-key"
  url "https://github.com/justbur/emacs-which-key/archive/v1.2.0.tar.gz"
  sha256 "d8eb92f348c5075a989cb567f57921f78569965fadde5e7c76bb772d6ba4affc"
  head "https://github.com/justbur/emacs-which-key.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9bd60fa11ee62ab2977fffb0de354e4dac55cfe90e136d079027da44a8210c1f" => :sierra
    sha256 "9bd60fa11ee62ab2977fffb0de354e4dac55cfe90e136d079027da44a8210c1f" => :el_capitan
    sha256 "9bd60fa11ee62ab2977fffb0de354e4dac55cfe90e136d079027da44a8210c1f" => :yosemite
  end

  depends_on :emacs => "24.3"

  def install
    ert_run_tests "which-key-tests.el"
    byte_compile "which-key.el"
    elisp.install "which-key.el", "which-key.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "which-key")
      (which-key-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

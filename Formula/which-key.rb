require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WhichKey < EmacsFormula
  desc "Emacs package for displaying available keybindings"
  homepage "https://github.com/justbur/emacs-which-key"
  url "https://github.com/justbur/emacs-which-key/archive/v0.7.tar.gz"
  sha256 "2623998b024d0c47d633282f12f2b775c66d9c93739f9f679ea601963f2f1581"
  head "https://github.com/justbur/emacs-which-key.git"

  depends_on :emacs => "24.3"

  def install
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

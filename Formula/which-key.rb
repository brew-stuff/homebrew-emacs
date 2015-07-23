require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WhichKey < EmacsFormula
  desc "Emacs package for displaying available keybindings"
  homepage "https://github.com/justbur/emacs-which-key"
  url "https://github.com/justbur/emacs-which-key/archive/v0.4.1.tar.gz"
  sha256 "88770ff67fbb50c287ce28095868859639640f84ead2f1c05c870c7a9335120a"
  head "https://github.com/justbur/emacs-which-key.git"

  depends_on :emacs => "24.3"
  depends_on "dunn/emacs/dash"
  depends_on "dunn/emacs/s"

  def install
    byte_compile "which-key.el"
    (share/"emacs/site-lisp/which-key").install "which-key.el",
                                                "which-key.elc"
    doc.install "README.org"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'which-key)
    (which-key-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "which-key")
      (which-key-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

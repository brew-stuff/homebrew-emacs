require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AggressiveIndent < EmacsFormula
  desc "Emacs minor mode to keep code always indented"
  homepage "https://github.com/Malabarba/aggressive-indent-mode"
  url "https://github.com/Malabarba/aggressive-indent-mode/archive/1.5.tar.gz"
  sha256 "e9a36020bb88b477d183d606a41bc6f40a2caec8e1f0384c16133acb485187ef"
  head "https://github.com/Malabarba/aggressive-indent-mode.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile "aggressive-indent.el"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/aggressive-indent")
      (load "aggressive-indent")
      (global-aggressive-indent-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

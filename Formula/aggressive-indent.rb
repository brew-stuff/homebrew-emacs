require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AggressiveIndent < EmacsFormula
  desc "Emacs minor mode to keep code always indented"
  homepage "https://github.com/Malabarba/aggressive-indent-mode"
  url "https://github.com/Malabarba/aggressive-indent-mode/archive/1.5.1.tar.gz"
  sha256 "33c96343a34f48e771384923b3eb08edade75c51f5d94ebc9b93f0213d35c4cd"
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

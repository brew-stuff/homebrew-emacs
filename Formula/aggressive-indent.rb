require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AggressiveIndent < EmacsFormula
  desc "Emacs minor mode to keep code always indented"
  homepage "https://github.com/Malabarba/aggressive-indent-mode"
  url "https://github.com/Malabarba/aggressive-indent-mode/archive/1.4.1.tar.gz"
  sha256 "e29f35ee77f421686c50352142a59eeaceaaaf28999691940a47a78732dc1bfe"
  head "https://github.com/Malabarba/aggressive-indent-mode.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/names"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile "aggressive-indent.el"
    (share/"emacs/site-lisp/aggressive-indent").install Dir["*.el"],
                                                        Dir["*.elc"]
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

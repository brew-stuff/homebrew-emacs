require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AggressiveIndent < EmacsFormula
  desc "Emacs minor mode to keep code always indented"
  homepage "https://github.com/Malabarba/aggressive-indent-mode"
  url "https://github.com/Malabarba/aggressive-indent-mode/archive/1.1.tar.gz"
  sha256 "80c4f681800506cf48606a3db017eff8c33ce763f36bdea4e2e8ba6e7888f030"
  head "https://github.com/Malabarba/aggressive-indent-mode.git"

  depends_on :emacs => "24.1"
  depends_on "dunn/emacs/names"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile "aggressive-indent.el"
    (share/"emacs/site-lisp/aggressive-indent").install Dir["*.el"],
                                                        Dir["*.elc"]
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add something like the following to your init file:

    (require 'aggressive-indent)
    (global-aggressive-indent-mode 1)
    (add-to-list 'aggressive-indent-excluded-modes 'html-mode)
  EOS
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

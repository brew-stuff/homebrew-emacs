require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Smartparens < EmacsFormula
  desc "Minor mode for Emacs that deals with parens pairs"
  homepage "https://github.com/Fuco1/smartparens"
  url "https://github.com/Fuco1/smartparens/archive/1.10.1.tar.gz"
  sha256 "715051817d688449708a252dc72b056f281a4eaf769a2c441e58f6b59c899adb"
  head "https://github.com/Fuco1/smartparens.git"

  bottle :disable

  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")
  depends_on "dunn/emacs/dash-emacs"

  def install
    rm "smartparens-pkg.el"
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/cl-lib"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/dash-emacs"].opt_elisp}")
      (load "smartparens")
      (turn-on-smartparens-mode)
      (turn-off-smartparens-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

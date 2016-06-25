require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class GoMode < EmacsFormula
  desc "Emacs major mode for editing Go"
  homepage "https://github.com/dominikh/go-mode.el"
  url "https://github.com/dominikh/go-mode.el/archive/v1.4.0.tar.gz"
  sha256 "31365aa8b220ca67e6fb24fa197e99121a6db815690df731df2f56915805935d"
  head "https://github.com/dominikh/go-mode.el"

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "go-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class GoMode < EmacsFormula
  desc "Emacs major mode for editing Go"
  homepage "https://github.com/dominikh/go-mode.el"
  url "https://github.com/dominikh/go-mode.el/archive/v1.5.0.tar.gz"
  sha256 "d54a4afac1658082da1f26bab486c346262e5b185e6463cfe316a3e5e57ab6a9"
  head "https://github.com/dominikh/go-mode.el"

  depends_on :emacs => "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

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

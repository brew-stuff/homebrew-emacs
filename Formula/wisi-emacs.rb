require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WisiEmacs < EmacsFormula
  desc "Indentation/navigation in Emacs using a LALR parser"
  homepage "http://www.nongnu.org/ada-mode/wisi/wisi.html"
  url "https://elpa.gnu.org/packages/wisi-1.1.5.tar"
  sha256 "448dee9cff401b9ddb471d37afe40118531ef3e534b05dca0070bf04a75f0de0"

  bottle :disable

  depends_on :emacs => "24.2"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile (Dir["*.el"] - ["wisi-pkg.el"])
    elisp.install (Dir["*.el"] - ["wisi-pkg.el"]), Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "wisi")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ZtreeEmacs < EmacsFormula
  desc "Emacs modes for directory tree comparison"
  homepage "https://github.com/fourier/ztree"
  url "https://elpa.gnu.org/packages/ztree-1.0.4.tar"
  sha256 "f04a0cdfa827802c7cf6ec0fafbf7b0a8c8f27ae9b471d403a1f69608c523176"
  head "https://github.com/fourier/ztree.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "ztree")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CythonMode < EmacsFormula
  desc "Emacs major mode for Cython"
  homepage "http://cython.org"
  url "https://github.com/cython/cython/archive/0.24.tar.gz"
  sha256 "b60b91f1ec88921a423d5f0a5e2a7c232cdff12d9130088014bf89d542ce137b"
  head "https://github.com/cython/cython.git"

  depends_on :emacs

  def install
    cd "Tools"
    byte_compile "cython-mode.el"
    elisp.install "cython-mode.el", "cython-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "cython-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

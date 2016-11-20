require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CythonMode < EmacsFormula
  desc "Emacs major mode for Cython"
  homepage "http://cython.org"
  url "https://github.com/cython/cython/archive/0.25.1.tar.gz"
  sha256 "1cda0c5b6ebe9a6df19993cabbe747e35e6f540d438e1a750f4fc8a17b3a7d37"
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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CythonMode < EmacsFormula
  desc "Emacs major mode for Cython"
  homepage "http://cython.org"
  url "https://github.com/cython/cython/archive/0.25.2.tar.gz"
  sha256 "206b6fc7e8cebe8e0529064a92e4f53f13a8f1d1f4dc173c32782ab134a2551e"
  head "https://github.com/cython/cython.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a5a537e5b5ee82d787c07439c742d5af4e0fef0332c8b873565454c5b7886e3" => :sierra
    sha256 "cdaa605270201cb75a52b9f08c9e8cdb07c60856cb75765d66e4dc022e71213c" => :el_capitan
    sha256 "cdaa605270201cb75a52b9f08c9e8cdb07c60856cb75765d66e4dc022e71213c" => :yosemite
  end

  depends_on EmacsRequirement

  def install
    cd "Tools"
    byte_compile "cython-mode.el"
    elisp.install "cython-mode.el", "cython-mode.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "cython-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

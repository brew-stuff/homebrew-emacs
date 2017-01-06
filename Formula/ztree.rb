require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Ztree < EmacsFormula
  desc "Emacs modes for directory tree comparison"
  homepage "https://github.com/fourier/ztree"
  url "https://elpa.gnu.org/packages/ztree-1.0.4.tar"
  sha256 "f04a0cdfa827802c7cf6ec0fafbf7b0a8c8f27ae9b471d403a1f69608c523176"
  head "https://github.com/fourier/ztree.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "50bf2f4102a9da94c9bc4e73f67677072d1ff01deeff5ec28ec4e6ed9a9f0471" => :sierra
    sha256 "50bf2f4102a9da94c9bc4e73f67677072d1ff01deeff5ec28ec4e6ed9a9f0471" => :el_capitan
    sha256 "50bf2f4102a9da94c9bc4e73f67677072d1ff01deeff5ec28ec4e6ed9a9f0471" => :yosemite
  end

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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ZtreeEmacs < EmacsFormula
  desc "Emacs modes for directory tree comparison"
  homepage "https://github.com/fourier/ztree"
  url "http://elpa.gnu.org/packages/ztree-1.0.2.tar"
  sha256 "c598274691e6a7a079d37790973cceb2c9b238823321bcdefaa9d5c2d959a966"
  head "https://github.com/fourier/ztree.git"

  depends_on :emacs => "24.1"

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

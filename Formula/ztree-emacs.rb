require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ZtreeEmacs < EmacsFormula
  desc "Emacs modes for directory tree comparison"
  homepage "https://github.com/fourier/ztree"
  url "http://elpa.gnu.org/packages/ztree-1.0.3.tar"
  sha256 "5c53daa061686b2276f50f7a5584ab82596a21b71dff4aab2c9c40a511999fd7"
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

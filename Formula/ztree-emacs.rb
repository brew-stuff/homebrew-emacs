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
    (share/"emacs/site-lisp/ztree").install Dir["*.el"],
                                            Dir["*.elc"]
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'ztree)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "ztree")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

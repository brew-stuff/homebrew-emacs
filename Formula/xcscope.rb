require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Xcscope < EmacsFormula
  desc "cscope interface for (X)Emacs"
  homepage "https://github.com/dkogan/xcscope.el"
  url "https://github.com/dkogan/xcscope.el/archive/v1.2.tar.gz"
  sha256 "47e05cf03e9f460426de6d1bec6871bec90853d5f599edbdb0e3f0428b59a197"
  head "https://github.com/dkogan/xcscope.el.git"

  depends_on :emacs
  depends_on "cscope"

  def install
    byte_compile "xcscope.el"
    elisp.install "xcscope.el", "xcscope.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/xcscope")
      (load "xcscope")
      (cscope-setup)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

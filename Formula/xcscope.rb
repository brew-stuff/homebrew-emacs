require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Xcscope < EmacsFormula
  desc "cscope interface for (X)Emacs"
  homepage "https://github.com/dkogan/xcscope.el"
  url "https://github.com/dkogan/xcscope.el/archive/v1.3.tar.gz"
  sha256 "69d80db62d1c4354cd1bb04df401b8c329658bd1e9262e28b8e81a80abb0e09b"
  head "https://github.com/dkogan/xcscope.el.git"

  depends_on EmacsRequirement
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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Xcscope < EmacsFormula
  desc "cscope interface for (X)Emacs"
  homepage "https://github.com/dkogan/xcscope.el"
  url "https://github.com/dkogan/xcscope.el/archive/v1.1.tar.gz"
  sha256 "f4458437d9cfe02299eeca56c760238c6909a4c0eab4677a578596920c02be6c"
  head "https://github.com/dkogan/xcscope.el.git"

  depends_on :emacs
  depends_on "cscope"

  def install
    byte_compile "xcscope.el"
    (share/"emacs/site-lisp/xcscope").install "xcscope.el",
                                              "xcscope.elc"
    doc.install "README.org"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'xcscope)
    (cscope-setup)
  EOS
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

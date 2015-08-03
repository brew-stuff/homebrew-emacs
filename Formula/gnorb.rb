require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Gnorb < EmacsFormula
  desc "Glue code between Gnus, Org, and BBDB in Emacs"
  homepage "https://github.com/girzel/gnorb"
  url "http://elpa.gnu.org/packages/gnorb-1.1.1.tar"
  sha256 "aadf76a504dcf0acfa0884178376dc6006162d4257c9e447bca9b66b2d7b22da"
  head "https://github.com/girzel/gnorb.git"

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/gnorb").install Dir["*.el"],
                                            Dir["*.elc"]
    doc.install "README.org", "gnorb.texi"
    info.install "gnorb.info"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'gnorb)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/gnorb")
      (load "gnorb")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

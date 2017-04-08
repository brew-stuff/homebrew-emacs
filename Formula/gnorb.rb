require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Gnorb < EmacsFormula
  desc "Glue code between Gnus, Org, and BBDB"
  homepage "https://elpa.gnu.org/packages/gnorb.html"
  url "https://elpa.gnu.org/packages/gnorb-1.2.3.tar"
  sha256 "87f542c07e1c6e412487130d6dd95113bc0c58acaefbef1ed9a42a25220215af"

  bottle :disable

  depends_on :emacs
  depends_on "dunn/emacs/org-mode" if Emacs.version < Version.create("24.1")
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
    doc.install "gnorb.texi"
    info.install "gnorb.info"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "gnorb")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

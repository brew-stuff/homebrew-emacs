require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Gnorb < EmacsFormula
  desc "Glue code between Gnus, Org, and BBDB in Emacs"
  homepage "https://elpa.gnu.org/packages/gnorb.html"
  url "https://elpa.gnu.org/packages/gnorb-1.2.2.tar"
  sha256 "f55049ef93c15985b1dd3affd79ffb3c3891d6b784aa82b14137327d8faf7ab2"

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

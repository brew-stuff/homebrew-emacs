require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Gnorb < EmacsFormula
  desc "Glue code between Gnus, Org, and BBDB in Emacs"
  homepage "https://github.com/girzel/gnorb"
  url "https://elpa.gnu.org/packages/gnorb-1.2.1.tar"
  sha256 "3d3db528c6fb84ed7b9e4f82d7a0646a25f95589b12a9e7e3782b6bb3f033756"
  head "https://github.com/girzel/gnorb.git"

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

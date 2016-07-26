require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Gnorb < EmacsFormula
  desc "Glue code between Gnus, Org, and BBDB in Emacs"
  homepage "https://github.com/girzel/gnorb"
  url "http://elpa.gnu.org/packages/gnorb-1.1.2.tar"
  sha256 "7db3ddc270a26905f0635eae53af3ac24694ec4fdb4a3aaa498fd13176e3a5a1"
  head "https://github.com/girzel/gnorb.git"

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

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

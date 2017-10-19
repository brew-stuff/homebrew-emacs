require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Gnorb < EmacsFormula
  desc "Glue code between Gnus, Org, and BBDB"
  homepage "https://elpa.gnu.org/packages/gnorb.html"
  url "https://elpa.gnu.org/packages/gnorb-1.5.3.tar"
  sha256 "291619c9ca79bce8ba1914a994bd6d5a34ee039cc3ae1f94ed26f99e4fd9a9d2"

  bottle :disable

  depends_on EmacsRequirement => "25.1"

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
    doc.install "gnorb.texi"
    info.install "gnorb.info"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "gnorb")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

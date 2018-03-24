require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Muse < EmacsFormula
  desc "Authoring and publishing environment for Emacs"
  homepage "https://www.gnu.org/software/emacs-muse/"
  url "https://elpa.gnu.org/packages/muse-3.20.2.tar"
  sha256 "96a39d0115e26e643f2cf4646521f4522429d7983a8c3b6d2b53f442ba714e3c"
  head "https://github.com/alexott/muse.git"

  bottle :disable

  depends_on EmacsRequirement => "21.1"
  depends_on "dunn/emacs/htmlize"

  def install
    rm "muse-pkg.el"

    info.install "muse.info"
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "muse-mode")
      (load "muse-project")

      (load "muse-html")
      (load "muse-latex")
      (load "muse-texinfo")
      (load "muse-docbook")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

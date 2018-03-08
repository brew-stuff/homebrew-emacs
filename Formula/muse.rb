require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Muse < EmacsFormula
  desc "Authoring and publishing environment for Emacs"
  homepage "https://www.gnu.org/software/emacs-muse/"
  url "https://elpa.gnu.org/packages/muse-3.20.1.tar"
  sha256 "5eb1128f9fa0eaf3f6a56db3f99aa8fab299ef2031d491bebe29948c40ed1441"
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

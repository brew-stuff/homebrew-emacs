require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class LmcEmacs < EmacsFormula
  desc "Emacs lisp simulator for the Little Man Computer"
  homepage "https://elpa.gnu.org/packages/lmc.html"
  url "https://elpa.gnu.org/packages/lmc-1.4.el"
  sha256 "50400d6861c7b065c7947747e20b991a88d10b08bfea120c68e0bdd429d3a43a"

  depends_on :emacs
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    mv "lmc-#{version}.el", "lmc.el"
    byte_compile "lmc.el"
    elisp.install "lmc.el", "lmc.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "lmc")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

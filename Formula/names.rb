require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Names < EmacsFormula
  desc "Namespacing for Emacs Lisp"
  homepage "https://github.com/Malabarba/names"
  url "http://elpa.gnu.org/packages/names-20151201.0.tar"
  sha256 "4d84c4cf981b0d3597f0e94668e1e31352f477b08fd2fdef699ef43480d3558f"
  head "https://github.com/Malabarba/names.git"

  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/names")
      (load "names")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../Homebrew/emacs_formula", __dir__)

class OscEmacs < EmacsFormula
  desc "Emacs library for OpenSound Control"
  homepage "http://elpa.gnu.org/packages/osc.html"
  url "http://elpa.gnu.org/packages/osc-0.1.el"
  sha256 "4b5bdd2c622b3b3f0ec3211c1071e88c6267de327b71c543aa32bbbeff5adf26"

  depends_on EmacsRequirement
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    mv "osc-#{version}.el", "osc.el"
    byte_compile "osc.el"
    (share/"emacs/site-lisp/osc").install "osc.el",
                                          "osc.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/osc")
      (load "osc")
      (setq pid (osc-make-client "localhost" "8080"))
      (delete-process pid)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

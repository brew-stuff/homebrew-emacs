require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Crisp < EmacsFormula
  desc "Emacs emulator for CRiSP/Brief"
  homepage "http://elpa.gnu.org/packages/crisp.html"
  url "http://elpa.gnu.org/packages/crisp-1.3.4.el"
  sha256 "11589f5526680d76d6aa8d0ac7ce1bef3bb1e05bc2cf92adfe29114efb7176f5"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/crisp/crisp.el"

  depends_on EmacsRequirement

  def install
    mv "crisp-#{version}.el", "crisp.el"

    byte_compile "crisp.el"
    (share/"emacs/site-lisp/crisp").install "crisp.el",
                                            "crisp.elc"
  end

  def caveats
    <<~EOS
      Add the following to your init file:

      (require 'crisp)
    EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/crisp")
      (load "crisp")
      (crisp-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class NhexlMode < EmacsFormula
  desc "Emacs minor mode for editing hex dumps"
  homepage "http://elpa.gnu.org/packages/nhexl-mode.html"
  url "http://elpa.gnu.org/packages/nhexl-mode-0.1.el"
  sha256 "3271fe2fbf215c599f44781d15c9997363d65c5264d7dc3be12ac98c5aa19340"

  depends_on :emacs

  def install
    mv "nhexl-mode-#{version}.el", "nhexl-mode.el"
    byte_compile "nhexl-mode.el"
    (share/"emacs/site-lisp/nhexl-mode").install "nhexl-mode.el",
                                                 "nhexl-mode.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'nhexl-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/nhexl-mode")
      (load "nhexl-mode")
      (nhexl-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

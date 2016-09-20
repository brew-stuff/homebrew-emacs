require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class F90InterfaceBrowser < EmacsFormula
  desc "Fortran editing helpers for Emacs"
  homepage "https://elpa.gnu.org/packages/f90-interface-browser.html"
  url "https://github.com/wence-/f90-iface/archive/elpa-v1.1.tar.gz"
  sha256 "af2b935143e14e11f274066e632e37d6e35efde4de8ba076be872c43f441619e"

  depends_on :emacs

  def install
    byte_compile "f90-interface-browser.el"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "f90-interface-browser")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

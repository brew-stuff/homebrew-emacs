require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class F90InterfaceBrowser < EmacsFormula
  desc "Fortran editing helpers for Emacs"
  homepage "https://github.com/wence-/f90-iface"
  url "https://github.com/wence-/f90-iface/archive/elpa-v1.1.tar.gz"
  sha256 "af2b935143e14e11f274066e632e37d6e35efde4de8ba076be872c43f441619e"
  head "https://github.com/wence-/f90-iface.git"

  depends_on :emacs

  def install
    byte_compile "f90-interface-browser.el"
    (share/"emacs/site-lisp/f90-interface-browser").install Dir["*.el"],
                                                            Dir["*.elc"]
    doc.install "README.org" if build.head?
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'f90-interface-browser)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "f90-interface-browser")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

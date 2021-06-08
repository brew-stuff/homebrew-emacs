require File.expand_path("../Homebrew/emacs_formula", __dir__)

class F90InterfaceBrowser < EmacsFormula
  desc "Fortran editing helpers for Emacs"
  homepage "https://elpa.gnu.org/packages/f90-interface-browser.html"
  url "https://github.com/wence-/f90-iface/archive/elpa-v1.1.tar.gz"
  sha256 "af2b935143e14e11f274066e632e37d6e35efde4de8ba076be872c43f441619e"

  bottle do
    cellar :any_skip_relocation
    sha256 "11d1af4867f71f99983df7901b5190f7ab6dae55663eea0ee840c014a0138911" => :sierra
    sha256 "11d1af4867f71f99983df7901b5190f7ab6dae55663eea0ee840c014a0138911" => :el_capitan
    sha256 "11d1af4867f71f99983df7901b5190f7ab6dae55663eea0ee840c014a0138911" => :yosemite
  end

  depends_on EmacsRequirement

  def install
    byte_compile "f90-interface-browser.el"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "f90-interface-browser")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

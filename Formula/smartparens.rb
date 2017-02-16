require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Smartparens < EmacsFormula
  desc "Minor mode for Emacs that deals with parens pairs"
  homepage "https://github.com/Fuco1/smartparens"
  url "https://github.com/Fuco1/smartparens/archive/1.9.0.tar.gz"
  sha256 "9834d1b0d93b0a5b308e56213f81c18cf0d9483163d6822d453be9004f2e0688"
  head "https://github.com/Fuco1/smartparens.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "121efa69b9017a48b4c70d0b04b7f3757938da7b20ccd9df3adf29f54acfe5b2" => :sierra
    sha256 "121efa69b9017a48b4c70d0b04b7f3757938da7b20ccd9df3adf29f54acfe5b2" => :el_capitan
    sha256 "121efa69b9017a48b4c70d0b04b7f3757938da7b20ccd9df3adf29f54acfe5b2" => :yosemite
  end

  depends_on :emacs => "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")
  depends_on "dunn/emacs/dash-emacs"

  def install
    rm "smartparens-pkg.el"
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
    doc.install "smartparens.org"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/dash-emacs"].opt_elisp}")
      (load "smartparens")
      (turn-on-smartparens-mode)
      (turn-off-smartparens-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

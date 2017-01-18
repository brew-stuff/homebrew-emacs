require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class GnugoEmacs < EmacsFormula
  desc "Emacs interface to GNU Go"
  homepage "http://www.gnuvola.org/software/gnugo/"
  url "https://elpa.gnu.org/packages/gnugo-3.0.1.tar"
  sha256 "f70ef92dcb53f7a4a0246d4f91933ef6c4b226e4951d01b0fdadeb5dd383e223"

  bottle do
    cellar :any_skip_relocation
    sha256 "fab6f023b46fd04d6435ca016ee7394b07a3f85e29641f187c67999de428a04e" => :sierra
    sha256 "86b2696b34839ec9fa1e2af7b5d116bda62b34f45ddaf15dc5fbe712b61bca1f" => :el_capitan
    sha256 "86b2696b34839ec9fa1e2af7b5d116bda62b34f45ddaf15dc5fbe712b61bca1f" => :yosemite
  end

  depends_on :emacs
  depends_on "homebrew/games/gnu-go"
  depends_on "homebrew/emacs/ascii-art-to-unicode"
  depends_on "homebrew/emacs/xpm-emacs"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "gnugo")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ChessEmacs < EmacsFormula
  desc "Chess module for Emacs"
  homepage "http://elpa.gnu.org/packages/chess.html"
  url "http://elpa.gnu.org/packages/chess-2.0.4.tar"
  sha256 "5a16dbd56432be81f1c313fc88972ac690c2dc5a82c1035da37b8472ab5c01eb"
  head "http://git.savannah.gnu.org/r/emacs/elpa.git",
       :branch => "externals/chess"

  depends_on :emacs => "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < 24.3

  def install
    system "make", "test" if build.head?
    byte_compile Dir["*.el"]

    (share/"emacs/site-lisp/chess").install Dir["*.el"], Dir["*.elc"]
    info.install "chess.info"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'chess)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/chess")
      (load "chess")
      (print chess-version)
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

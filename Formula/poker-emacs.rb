require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PokerEmacs < EmacsFormula
  desc "Texas Hold'Em Poker for Emacs"
  homepage "https://elpa.gnu.org/packages/poker.html"
  url "https://elpa.gnu.org/packages/poker-0.2.el"
  sha256 "00b8a4953460c753e853dc093cf215ff836140de2fc41d3de4fbdb5de3d5336a"

  depends_on emacs: "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    mv "poker-#{version}.el", "poker.el"
    byte_compile "poker.el"
    elisp.install "poker.el", "poker.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "poker")
      (print (poker-random-deck))
    EOS
    assert_equal 52, shell_output("emacs -Q --batch -l #{testpath}/test.el")
      .strip.gsub(/[()"]/, "")
      .split(" ").length
  end
end

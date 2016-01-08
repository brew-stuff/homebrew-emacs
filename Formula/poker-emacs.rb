require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PokerEmacs < EmacsFormula
  desc "Texas Hold'Em Poker for Emacs"
  homepage "http://elpa.gnu.org/packages/poker.html"
  url "http://elpa.gnu.org/packages/poker-0.1.el"
  sha256 "e0bd037d3119a203973910c1207b42eb0617db4bbea17db23107e8656a2a753d"

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

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
    assert_equal 52, shell_output("emacs -Q --batch -l #{testpath}/test.el").
      strip.gsub(/[()"]/, "").
      split(" ").length
  end
end

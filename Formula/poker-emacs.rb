require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PokerEmacs < EmacsFormula
  desc "Texas Hold'Em Poker for Emacs"
  homepage "https://elpa.gnu.org/packages/poker.html"
  url "https://elpa.gnu.org/packages/poker-0.2.el"
  sha256 "00b8a4953460c753e853dc093cf215ff836140de2fc41d3de4fbdb5de3d5336a"

  bottle do
    cellar :any_skip_relocation
    sha256 "c94d19d10fccf200c9a51a4b439e9d24678a80ff151a7638ef635176803905d2" => :sierra
    sha256 "c94d19d10fccf200c9a51a4b439e9d24678a80ff151a7638ef635176803905d2" => :el_capitan
    sha256 "c94d19d10fccf200c9a51a4b439e9d24678a80ff151a7638ef635176803905d2" => :yosemite
  end

  depends_on emacs: "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

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

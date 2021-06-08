require File.expand_path("../Homebrew/emacs_formula", __dir__)

class ScrollRestore < EmacsFormula
  desc "Emacs minor mode to restore point after scrolling"
  homepage "https://elpa.gnu.org/packages/scroll-restore.html"
  url "https://elpa.gnu.org/packages/scroll-restore-1.0.el"
  sha256 "164e232bcdf72fdd0fae9c5b742888c4f863c9a168ef67da66f5d759e9d7a540"

  bottle do
    cellar :any_skip_relocation
    sha256 "0151cec65c17775e1344619ce240fe892653193ca9c87eee97eca85c293c344c" => :sierra
    sha256 "0151cec65c17775e1344619ce240fe892653193ca9c87eee97eca85c293c344c" => :el_capitan
    sha256 "0151cec65c17775e1344619ce240fe892653193ca9c87eee97eca85c293c344c" => :yosemite
  end

  depends_on EmacsRequirement

  def install
    mv "scroll-restore-#{version}.el", "scroll-restore.el"
    byte_compile "scroll-restore.el"
    elisp.install "scroll-restore.el", "scroll-restore.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "scroll-restore")
      (scroll-restore-remove)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

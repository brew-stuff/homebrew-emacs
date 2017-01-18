require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Neotree < EmacsFormula
  desc "Tree-style file browser for Emacs"
  homepage "https://github.com/jaypei/emacs-neotree"
  url "https://github.com/jaypei/emacs-neotree/archive/0.5.1.tar.gz"
  sha256 "1d517543bcc3d7df92a1262410266febee47b9a294d9380183bf3fa735c6fc39"
  head "https://github.com/jaypei/emacs-neotree.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "57a1fe46267ebf430157af2ffb074babfa8aeb1a9441ba42b6518913f0d99b31" => :sierra
    sha256 "9ff4c17f5d226dbfb7456fdd8bb2dffd63c02d52a2de1034dfd18b6533fc8cfa" => :el_capitan
    sha256 "9ff4c17f5d226dbfb7456fdd8bb2dffd63c02d52a2de1034dfd18b6533fc8cfa" => :yosemite
  end

  depends_on :emacs => "24.1"

  def install
    system "make", "test-batch"
    elisp.install "neotree.el", "neotree.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "neotree")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Neotree < EmacsFormula
  desc "Tree-style file browser for Emacs"
  homepage "https://github.com/jaypei/emacs-neotree"
  url "https://github.com/jaypei/emacs-neotree/archive/0.5.tar.gz"
  sha256 "208ba914cc8b2d65ecc69db1ada3066c61d9d5b541529d566e0161cf390bf330"
  head "https://github.com/jaypei/emacs-neotree.git", :branch => "dev"

  bottle do
    cellar :any_skip_relocation
    sha256 "66b99c96b3b183db861e7e9805bd12a541df2c55b12cc50c2ef33f560896307b" => :sierra
    sha256 "66b99c96b3b183db861e7e9805bd12a541df2c55b12cc50c2ef33f560896307b" => :el_capitan
    sha256 "66b99c96b3b183db861e7e9805bd12a541df2c55b12cc50c2ef33f560896307b" => :yosemite
  end

  depends_on :emacs

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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Neotree < EmacsFormula
  desc "Tree-style file browser for Emacs"
  homepage "https://github.com/jaypei/emacs-neotree"
  url "https://github.com/jaypei/emacs-neotree/archive/v0.2.1.tar.gz"
  sha256 "fae0816cbd7ba051b6918caefeaccb09e700ddd47215cd9d8cee493edb3d2333"
  head "https://github.com/jaypei/emacs-neotree.git", :branch => "dev"

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

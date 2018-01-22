require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Neotree < EmacsFormula
  desc "Tree-style file browser for Emacs"
  homepage "https://github.com/jaypei/emacs-neotree"
  url "https://github.com/jaypei/emacs-neotree/archive/0.5.2.tar.gz"
  sha256 "22dc07fc170ebb2c69353fcd4680a06824fd42b9cc41f6e6715646cf216ba6fd"
  head "https://github.com/jaypei/emacs-neotree.git", :branch => "dev"

  bottle :disable

  depends_on EmacsRequirement => "24.1"

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

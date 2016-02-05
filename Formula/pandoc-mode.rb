require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PandocMode < EmacsFormula
  desc "Emacs minor mode for interacting with pandoc"
  homepage "https://joostkremers.github.io/pandoc-mode/"
  url "https://github.com/joostkremers/pandoc-mode/archive/2.14.tar.gz"
  sha256 "27252dad4f97dc4ffb2f34503990be84f2abb6cf1b55cc49cd8e52b29086ab59"
  head "https://github.com/joostkremers/pandoc-mode.git"

  depends_on :emacs => "24.1"
  depends_on "pandoc"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/hydra-emacs"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
    info.install "dir", "pandoc-mode.info"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/hydra-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{elisp}")
      (load "pandoc-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PandocMode < EmacsFormula
  desc "Emacs minor mode for interacting with pandoc"
  homepage "https://joostkremers.github.io/pandoc-mode/"
  url "https://github.com/joostkremers/pandoc-mode/archive/2.13.1.tar.gz"
  sha256 "3ee2a2a76e16df7713d333d1854fb4574c550c9996982fa32d09f151ba36c16f"
  head "https://github.com/joostkremers/pandoc-mode.git"

  depends_on :emacs => "24.1"
  depends_on "pandoc"
  depends_on "dunn/emacs/dash"
  depends_on "dunn/emacs/hydra"

  def install
    # compilation fails: https://github.com/joostkremers/pandoc-mode/issues/49
    # test also fails for the same reason
    (share/"emacs/site-lisp/pandoc-mode").install Dir["*.el"]
    info.install "dir", "pandoc-mode.info"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp")
      (load "pandoc-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PandocMode < EmacsFormula
  desc "Emacs minor mode for interacting with pandoc"
  homepage "https://joostkremers.github.io/pandoc-mode/"
  head "https://github.com/joostkremers/pandoc-mode.git"

  stable do
    url "https://github.com/joostkremers/pandoc-mode/archive/2.13.1.tar.gz"
    sha256 "3ee2a2a76e16df7713d333d1854fb4574c550c9996982fa32d09f151ba36c16f"

    patch do
      url "https://github.com/joostkremers/pandoc-mode/commit/67692376b4f8f320ae674882426a9e7cd4ae25eb.diff"
      sha256 "410c146464d31cd87bb3550030d614a9de5f39653c9b18527cc9de509a6a5c38"
    end

    patch do
      url "https://github.com/joostkremers/pandoc-mode/commit/1fcce20ddebf336870fe7f67bbc07895794a6500.diff"
      sha256 "bcbc2c59c3bca8b551e1cd44f7d0376e1e150ab7ada1251b2e13e72b24b0bda3"
    end
  end

  depends_on :emacs => "24.1"
  depends_on "pandoc"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/hydra-emacs"

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/pandoc-mode").install Dir["*.el"], Dir["*.elc"]
    info.install "dir", "pandoc-mode.info"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'pandoc-mode)
    (add-hook 'markdown-mode-hook 'pandoc-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_share}/emacs/site-lisp/dash")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/hydra-emacs"].opt_share}/emacs/site-lisp/hydra")
      (add-to-list 'load-path "#{share}/emacs/site-lisp/pandoc-mode")
      (load "pandoc-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

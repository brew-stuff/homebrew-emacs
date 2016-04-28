require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DMode < EmacsFormula
  desc "Emacs major mode for D code"
  homepage "https://github.com/Emacs-D-Mode-Maintainers/Emacs-D-Mode"
  url "https://github.com/Emacs-D-Mode-Maintainers/Emacs-D-Mode/archive/v-2.0.7.tar.gz"
  sha256 "739b4623d4a44ab6a61138a60a91f2a591d9bcd318497d09d35820fa3c2bfc6e"
  head "https://github.com/Emacs-D-Mode-Maintainers/Emacs-D-Mode.git"

  depends_on :emacs => "23"
  depends_on "cask"

  def install
    system "make", "compile"
    elisp.install "d-mode.el", "d-mode.elc"
    prefix.install "gplv2.txt"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "d-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

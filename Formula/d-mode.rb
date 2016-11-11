require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DMode < EmacsFormula
  desc "Emacs major mode for D code"
  homepage "https://github.com/Emacs-D-Mode-Maintainers/Emacs-D-Mode"
  url "https://github.com/Emacs-D-Mode-Maintainers/Emacs-D-Mode/archive/2.0.9.tar.gz"
  sha256 "6d8e2f3f201a829fcad82353a85a22c627d78c007da5311ee1e78e1ecf51ea88"
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

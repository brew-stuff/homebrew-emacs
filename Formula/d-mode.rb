require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DMode < EmacsFormula
  desc "Emacs major mode for D code"
  homepage "https://github.com/Emacs-D-Mode-Maintainers/Emacs-D-Mode"
  url "https://github.com/Emacs-D-Mode-Maintainers/Emacs-D-Mode/archive/2.0.8.tar.gz"
  sha256 "80ab7e82ebbb6afe4c7d9ab8e4feb597d2f84bd91739ac04120954594a7cd74e"
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

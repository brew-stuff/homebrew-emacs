require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ScssMode < EmacsFormula
  desc "Major mode for editing .scss files in Emacs"
  homepage "https://github.com/antonj/scss-mode"
  url "https://github.com/antonj/scss-mode/archive/0.5.0.tar.gz"
  sha256 "765b06cd6f93763c5dc5903b1645d98ea9ea6f75f5d6bc96b68d979224f90812"
  head "https://github.com/antonj/scss-mode.git"

  depends_on :emacs

  def install
    byte_compile "scss-mode.el"
    elisp.install "scss-mode.el", "scss-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "scss-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

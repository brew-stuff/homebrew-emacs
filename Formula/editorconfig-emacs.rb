require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class EditorconfigEmacs < EmacsFormula
  desc "EditorConfig plugin for emacs"
  homepage "http://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-emacs/archive/v0.5.tar.gz"
  sha256 "7f4d7876109e2e25ee1beac071f85ed3687f69a1608b49adedbd3207f1357ae2"
  head "https://github.com/editorconfig/editorconfig-emacs.git"

  depends_on "editorconfig"
  depends_on :emacs => "24.1"

  def install
    system "make"
    system "make", "test"
    elisp.install "editorconfig.el", "editorconfig.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "editorconfig")
      (editorconfig-set-indentation "space")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

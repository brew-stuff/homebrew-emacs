require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class EditorconfigEmacs < EmacsFormula
  desc "EditorConfig plugin for emacs"
  homepage "http://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-emacs/archive/v0.4.tar.gz"
  sha256 "763405eb475f328105c5772cc03023ba8faca83fb60745b1bc9613b1ea1acea6"
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
      (edconf-set-indentation "space")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ListUnicodeDisplay < EmacsFormula
  desc " Search for and list unicode characters in Emacs "
  homepage "https://github.com/purcell/list-unicode-display.git"
  url "https://github.com/purcell/list-unicode-display/archive/0.1.tar.gz"
  sha256 "9f5f8a95aae6362cd1d4a1203e9e60aa2fef0b1bb3812d85605ca9ad41b70eb4"
  head "https://github.com/purcell/list-unicode-display.git"

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile "list-unicode-display.el"
    elisp.install "list-unicode-display.el", "list-unicode-display.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/cl-lib"].opt_elisp}")
      (load "list-unicode-display")
      (list-unicode-display "NULL")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

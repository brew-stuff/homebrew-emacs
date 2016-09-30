require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TextmateEmacs < EmacsFormula
  desc "Textmate-inspired minor mode"
  homepage "https://github.com/defunkt/textmate.el"
  url "https://github.com/defunkt/textmate.el/archive/v1.tar.gz"
  sha256 "1ce4475d4e80eed145a5055f25912d66e93b4ca10306679b09e9cc722f5bcec2"
  head "https://github.com/defunkt/textmate.el.git"

  depends_on :emacs

  def install
    byte_compile "textmate.el"
    elisp.install "textmate.el", "textmate.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "textmate")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

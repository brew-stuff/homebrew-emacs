require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AnzuMode < EmacsFormula
  desc "Emacs minor mode for numbering search results"
  homepage "https://github.com/syohex/emacs-anzu"
  url "https://github.com/syohex/emacs-anzu/archive/0.62.tar.gz"
  sha256 "9f91077d12bffc2d30640dfc5a5b627139d03c06bee9335f5df6977e121a8f99"
  head "https://github.com/syohex/emacs-anzu.git"

  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile "anzu.el"
    elisp.install "anzu.el", "anzu.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "anzu")
      (anzu-mode +1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

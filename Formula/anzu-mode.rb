require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AnzuMode < EmacsFormula
  desc "Emacs minor mode for numbering search results"
  homepage "https://github.com/syohex/emacs-anzu"
  url "https://github.com/syohex/emacs-anzu/archive/0.61.tar.gz"
  sha256 "9cd204fe295cf981937e8add88e15ee38366450bc62c329fc8006521a1a48c06"
  head "https://github.com/syohex/emacs-anzu.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile "anzu.el"
    elisp.install "anzu.el", "anzu.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "anzu")
      (anzu-mode +1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

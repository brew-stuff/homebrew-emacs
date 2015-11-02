require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TypoMode < EmacsFormula
  desc "Emacs minor mode for inserting typographic characters"
  homepage "https://github.com/jorgenschaefer/typoel"
  url "https://github.com/jorgenschaefer/typoel/archive/v1.1.tar.gz"
  sha256 "da7b345e7cb9e9934c8f0aa0b000e417e772636679c0e5ae6653269201e254e5"
  head "https://github.com/jorgenschaefer/typoel.git"

  depends_on :emacs

  def install
    byte_compile "typo.el"
    elisp.install "typo.el", "typo.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "typo")
      (typo-global-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

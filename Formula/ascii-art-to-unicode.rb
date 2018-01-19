require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AsciiArtToUnicode < EmacsFormula
  desc "Convert ASCII line art to Unicode line art"
  homepage "http://www.gnuvola.org/software/aa2u/"
  url "https://elpa.gnu.org/packages/ascii-art-to-unicode-1.11.el"
  sha256 "1a7d15cd24aaf79bff137bab50fe6fb7e6f17337bf6c168892d6c33df5953bfc"

  depends_on EmacsRequirement
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    mv "ascii-art-to-unicode-#{version}.el", "ascii-art-to-unicode.el"

    byte_compile "ascii-art-to-unicode.el"
    elisp.install "ascii-art-to-unicode.el", "ascii-art-to-unicode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/ascii-art-to-unicode")
      (load "ascii-art-to-unicode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

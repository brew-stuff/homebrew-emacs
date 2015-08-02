require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AsciiArtToUnicode < EmacsFormula
  desc "Convert ASCII line art to Unicode line art"
  homepage "http://www.gnuvola.org/software/aa2u/"
  url "http://elpa.gnu.org/packages/ascii-art-to-unicode-1.9.el"
  sha256 "bba9e158f755a3d74705a08ded026b20ded7e0a1bab38ec2688de880fa74cf51"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/ascii-art-to-unicode/ascii-art-to-unicode.el"

  depends_on :emacs

  def install
    mv "ascii-art-to-unicode-#{version}.el",
       "ascii-art-to-unicode.el" if build.stable?

    byte_compile "ascii-art-to-unicode.el"
    (share/"emacs/site-lisp/ascii-art-to-unicode").install Dir["*.el"],
                                                           Dir["*.elc"]
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'ascii-art-to-unicode)
  EOS
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

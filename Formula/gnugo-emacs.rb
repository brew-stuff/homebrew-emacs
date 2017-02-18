require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class GnugoEmacs < EmacsFormula
  desc "Emacs interface to GNU Go"
  homepage "http://www.gnuvola.org/software/gnugo/"
  url "https://elpa.gnu.org/packages/gnugo-3.1.0.tar"
  sha256 "c13dd1bbdf8ea0e3b20e403739ef03fa05c3280c4bb7ab380ee73d5084def276"

  bottle :disable

  depends_on :emacs
  depends_on "gnu-go"
  depends_on "dunn/emacs/ascii-art-to-unicode"
  depends_on "dunn/emacs/xpm-emacs"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile "gnugo.el", "gnugo-frolic.el", "gnugo-imgen.el"
    elisp.install "gnugo.el", "gnugo.elc",
                  "gnugo-frolic.el", "gnugo-frolic.elc",
                  "gnugo-imgen.el", "gnugo-imgen.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "gnugo")
      (print gnugo-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

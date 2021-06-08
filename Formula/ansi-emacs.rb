require File.expand_path("../Homebrew/emacs_formula", __dir__)

class AnsiEmacs < EmacsFormula
  desc "Emacs library to convert strings into ANSI"
  homepage "https://github.com/rejeep/ansi.el"
  url "https://github.com/rejeep/ansi.el/archive/v0.4.1.tar.gz"
  sha256 "884beed6a8d4c33d2f99fdf2b1092c4d06f18eaf2b250d4fb843a214d726528e"
  head "https://github.com/rejeep/ansi.el.git"

  depends_on EmacsRequirement
  depends_on "dunn/emacs/dash-emacs"
  depends_on "dunn/emacs/s-emacs"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile "ansi.el"
    elisp.install "ansi.el", "ansi.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/s-emacs"].opt_elisp}")
      (load "ansi")
      (print (ansi-red "honk"))
    EOS
    assert_equal "\"\e[31mhonk\e[0m\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

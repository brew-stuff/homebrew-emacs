require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class XpmEmacs < EmacsFormula
  desc "Emacs library for editing XPM images"
  homepage "http://www.gnuvola.org/software/xpm/"
  url "https://elpa.gnu.org/packages/xpm-1.0.4.tar"
  sha256 "303f629471ffc95d6b87b66302ed730bd53c1a7dd6cc07d6a82c41a8958fb51c"

  bottle :disable

  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile "xpm.el", "xpm-m2z.el"
    elisp.install "xpm.el", "xpm.elc",
                  "xpm-m2z.el", "xpm-m2z.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "xpm")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

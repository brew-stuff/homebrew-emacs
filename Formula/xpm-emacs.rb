require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class XpmEmacs < EmacsFormula
  desc "Emacs library for editing XPM images"
  homepage "http://www.gnuvola.org/software/xpm/"
  url "https://elpa.gnu.org/packages/xpm-1.0.3.tar"
  sha256 "e45281a2a361790fc1a7b17e360ab2c04a6032026d911d79448f7dde475a9361"
  revision 1

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

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

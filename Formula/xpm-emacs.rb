require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class XpmEmacs < EmacsFormula
  desc "Emacs library for editing XPM images"
  homepage "http://www.gnuvola.org/software/xpm/"
  url "http://elpa.gnu.org/packages/xpm-1.0.3.tar"
  sha256 "e45281a2a361790fc1a7b17e360ab2c04a6032026d911d79448f7dde475a9361"

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/xpm").install Dir["*.el"],
                                          Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/xpm")
      (load "xpm")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DarkroomMode < EmacsFormula
  desc "Emacs major mode to remove visual distractions"
  homepage "https://github.com/capitaomorte/darkroom"
  url "https://github.com/capitaomorte/darkroom/archive/0.2.tar.gz"
  sha256 "0dd1c3d8ba143601b9a558ff1fcf9cad75f11c44cbaca9ac5f10a1d7bdc3f725"
  head "https://github.com/capitaomorte/darkroom.git"

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile "darkroom.el"
    (share/"emacs/site-lisp/darkroom").install "darkroom.el",
                                               "darkroom.elc"
    doc.install "README.md" if build.head?
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'darkroom)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/darkroom")
      (load "darkroom")
      (darkroom-tentative-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

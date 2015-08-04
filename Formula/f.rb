require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class F < EmacsFormula
  desc "Emacs filesystem API"
  homepage "https://github.com/rejeep/f.el"
  url "https://github.com/rejeep/f.el/archive/v0.17.2.tar.gz"
  sha256 "9d4a6f59e4eeed6776440420eb41e65bfd20760a45bf2e4f9e950fe21a65afd8"
  head "https://github.com/rejeep/f.el.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/dash"
  depends_on "homebrew/emacs/s"

  def install
    # make test/compile requires emacs-parallel
    byte_compile "f.el"
    (share/"emacs/site-lisp/f").install "f.el", "f.elc"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'f)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/f")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash"].share}/emacs/site-lisp/dash")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/s"].share}/emacs/site-lisp/s")
      (load "f")
      (print (f-this-file))
    EOS
    assert_equal "\"#{testpath}/test.el\"",
                 shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

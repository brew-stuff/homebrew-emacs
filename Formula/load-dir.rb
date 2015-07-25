require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class LoadDir < EmacsFormula
  desc "Package for loading all Emacs Lisp files in a directory"
  homepage "http://elpa.gnu.org/packages/load-dir.html"
  url "http://elpa.gnu.org/packages/load-dir-0.0.3.el"
  sha256 "62e8f3238ad3623dda424fcef36b4dc01ac074b91515d1403ed59efc0c6bb970"

  depends_on :emacs

  def install
    mv "load-dir-#{version}.el", "load-dir.el"
    byte_compile "load-dir.el"
    (share/"emacs/site-lisp/load-dir").install "load-dir.el",
                                               "load-dir.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'load-dir)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "load-dir")
      (load-dir-one "#{share}/emacs/site-lisp/load-dir")
      (print load-dir-loaded)
    EOS
    assert_equal "(\"#{share}/emacs/site-lisp/load-dir/load-dir\")",
                 shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

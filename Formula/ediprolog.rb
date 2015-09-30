require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Ediprolog < EmacsFormula
  desc "Emacs functions for interacting with SWI-Prolog"
  homepage "http://elpa.gnu.org/packages/ediprolog.html"
  url "http://elpa.gnu.org/packages/ediprolog-1.1.el"
  sha256 "cd9b33fca95eb715baab42c1830a0874960d228aae14f28930f3e40f79640aa7"

  depends_on :emacs => "21.2"

  def install
    mv "ediprolog-#{version}.el", "ediprolog.el"
    byte_compile "ediprolog.el"
    (share/"emacs/site-lisp/ediprolog").install "ediprolog.el",
                                                "ediprolog.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/ediprolog")
      (load "ediprolog")
      (print ediprolog-version)
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

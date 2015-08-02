require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Ediprolog < EmacsFormula
  desc "Emacs functions for interacting with SWI-Prolog"
  homepage "http://elpa.gnu.org/packages/ediprolog.html"
  url "http://elpa.gnu.org/packages/ediprolog-1.0.el"
  sha256 "dc983af90f17ee4181f67d5d7f75e95cc837556d749a552d282bfac8d8032b0f"

  # untested below
  depends_on :emacs => "21.2"

  def install
    mv "ediprolog-#{version}.el", "ediprolog.el"
    byte_compile "ediprolog.el"
    (share/"emacs/site-lisp/ediprolog").install "ediprolog.el",
                                                "ediprolog.elc"
  end

  def caveats; <<-EOS.undent
    Add something like the following to your init file:

    (require 'ediprolog)
    (global-set-key [f10] 'ediprolog-dwim)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "ediprolog")
      (print ediprolog-version)
    EOS
    assert_match version.to_s, shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

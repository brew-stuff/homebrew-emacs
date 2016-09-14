# coding: utf-8
require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class W3 < EmacsFormula
  desc "Emacs web browser"
  homepage "http://elpa.gnu.org/packages/w3.html"
  url "http://elpa.gnu.org/packages/w3-4.0.49.tar"
  sha256 "6be119e18fb6d4130be22f3aafc7d75b91b0b6ee3b28ed3b42a2f3371619c306"
  head "http://git.savannah.gnu.org/r/emacs/elpa.git", :branch => "externals/w3"

  depends_on :emacs

  def install
    ert_run_tests "tests/url-test.el"

    # there's a Makefile.in but no configure or configure.ac
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/w3").install Dir["*.el"],
                                         Dir["*.elc"],
                                         "etc"
    prefix.install "contrib"
    doc.install "README", "texi"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'w3)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/w3")
      (load "w3")
      (print (w3-version))
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

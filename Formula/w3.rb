# coding: utf-8
require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class W3 < EmacsFormula
  desc "Emacs web browser"
  homepage "https://elpa.gnu.org/packages/w3.html"
  url "https://elpa.gnu.org/packages/w3-4.0.49.tar"
  sha256 "6be119e18fb6d4130be22f3aafc7d75b91b0b6ee3b28ed3b42a2f3371619c306"
  head "http://git.savannah.gnu.org/r/emacs/elpa.git", branch: "externals/w3"

  depends_on :emacs

  def install
    ert_run_tests "tests/url-test.el"

    # there's a Makefile.in but no configure or configure.ac
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"], "etc"
    prefix.install "contrib"
    doc.install "texi"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "w3")
      (print (w3-version))
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

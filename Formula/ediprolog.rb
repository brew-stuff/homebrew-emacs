require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Ediprolog < EmacsFormula
  desc "Emacs functions for interacting with SWI-Prolog"
  homepage "https://elpa.gnu.org/packages/ediprolog.html"
  url "https://elpa.gnu.org/packages/ediprolog-1.2.el"
  sha256 "5fb97c61fa51a5a68d4098458c34461fbc8362e0afbeacbcac202076ee762e0d"

  depends_on EmacsRequirement => "22.1"

  def install
    mv "ediprolog-#{version}.el", "ediprolog.el"
    byte_compile "ediprolog.el"
    elisp.install "ediprolog.el", "ediprolog.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "ediprolog")
      (print ediprolog-version)
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

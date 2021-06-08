require File.expand_path("../Homebrew/emacs_formula", __dir__)

class DismalMode < EmacsFormula
  desc "Emacs major mode for editing dismal spreadsheets"
  homepage "http://elpa.gnu.org/packages/dismal.html"
  url "http://elpa.gnu.org/packages/dismal-1.5.tar"
  sha256 "e610562530756e0714155643d9ee1d8847fe082b79237ea5cb9a4ec10c371aee"

  depends_on EmacsRequirement

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/dismal").install Dir["*.el"],
                                             Dir["*.elc"]
    doc.install "README", Dir["*.txt"], Dir["*.texi"]
  end

  def caveats
    <<~EOS
      Add something like the following to your init file:

      (setq dismal-directory "#{ENV["HOME"]}/Documents/dismal")
      (require 'dismal)
    EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/dismal")
      (setq dismal-directory "#{doc}")
      (load "dismal")
      (print dismal-version)
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class MetarEmacs < EmacsFormula
  desc "Emacs package for accessing METAR weather information"
  homepage "http://elpa.gnu.org/packages/metar.html"
  url "http://elpa.gnu.org/packages/metar-0.1.el"
  sha256 "28c4e562ee7a98eaa0b57f92c34b1f095dafb7e68b9cd2552f5008a0eff73f69"

  depends_on :emacs
  depends_on "dunn/emacs/cl-lib" if Emacs.version < 24.3

  def install
    mv "metar-#{version}.el", "metar.el"
    byte_compile "metar.el"
    (share/"emacs/site-lisp/metar").install "metar.el",
                                            "metar.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'metar)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/metar")
      (load "metar")
      (print (metar-get-record "SARC"))
    EOS
    assert_match "SARC", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

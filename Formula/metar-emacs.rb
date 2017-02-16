require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class MetarEmacs < EmacsFormula
  desc "Emacs package for accessing METAR weather info"
  homepage "https://elpa.gnu.org/packages/metar.html"
  url "https://elpa.gnu.org/packages/metar-0.2.el"
  sha256 "6e6a05b4a0324cc59fba8860bddd5e2a77a88546f6ca2900efd1404ad3c1df65"

  depends_on :emacs
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    mv "metar-#{version}.el", "metar.el"
    byte_compile "metar.el"
    elisp.install "metar.el", "metar.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "metar")
      (print (metar-get-record "SARC"))
    EOS
    assert_match "SARC", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

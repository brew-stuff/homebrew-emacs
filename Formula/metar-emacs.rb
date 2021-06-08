require File.expand_path("../Homebrew/emacs_formula", __dir__)

class MetarEmacs < EmacsFormula
  desc "Emacs package for accessing METAR weather info"
  homepage "https://elpa.gnu.org/packages/metar.html"
  url "https://elpa.gnu.org/packages/metar-0.3.el"
  sha256 "4f00867fc8a90975bbbdd5932783979427562c70bb3ec5adffbe2cdec106fb1d"

  depends_on EmacsRequirement
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    mv "metar-#{version}.el", "metar.el"
    byte_compile "metar.el"
    elisp.install "metar.el", "metar.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/cl-lib"].opt_elisp}")
      (load "metar")
      (print (cdr (metar-get-record "SARC")))
    EOS
    assert_match(/^"SARC\ .*/, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip)
  end
end

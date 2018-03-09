require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Debbugs < EmacsFormula
  desc "Emacs library for accessing Debbugs SOAP servers"
  homepage "https://elpa.gnu.org/packages/debbugs.html"
  url "https://elpa.gnu.org/packages/debbugs-0.14.tar"
  sha256 "5e69701e70b1ce373e7c38872e041fe44c0fe5950f64b9fb4388a201de668f1f"

  bottle :disable

  depends_on EmacsRequirement => "24.1"

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"], "Debbugs.wsdl"
    info.install Dir["*.info"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "debbugs")
      (print (car debbugs-servers))
    EOS
    assert_match "gnu.org", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

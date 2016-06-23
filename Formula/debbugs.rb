require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Debbugs < EmacsFormula
  desc "Emacs library for accessing Debbugs SOAP servers"
  homepage "https://elpa.gnu.org/packages/debbugs.html"
  url "https://elpa.gnu.org/packages/debbugs-0.9.7.tar"
  sha256 "189f14f7c60c925c57fbae34ee9b0020a0e34e0ae08e2d601c02564a5c1c871f"

  depends_on :emacs => "22.1"
  depends_on "homebrew/emacs/soap-client-emacs" if Emacs.version < 24.1

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"], "Debbugs.wsdl"
    info.install "debbugs.info"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "debbugs")
      (print (car debbugs-servers))
    EOS
    assert_match "gnu.org", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

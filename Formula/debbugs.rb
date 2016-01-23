require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Debbugs < EmacsFormula
  desc "Emacs library for accessing Debbugs SOAP servers"
  homepage "http://elpa.gnu.org/packages/debbugs.html"
  url "http://elpa.gnu.org/packages/debbugs-0.9.tar"
  sha256 "13281dc982a392e258e61000d209b1ca32fffc5401508f516f18c3080f9f86f1"

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

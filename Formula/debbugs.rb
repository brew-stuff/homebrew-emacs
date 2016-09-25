require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Debbugs < EmacsFormula
  desc "Emacs library for accessing Debbugs SOAP servers"
  homepage "https://elpa.gnu.org/packages/debbugs.html"
  url "https://elpa.gnu.org/packages/debbugs-0.11.tar"
  sha256 "d670f48dc5138301d5f02f77d881144cd7d761fc89390c8d34edbbedd5d16983"

  bottle do
    cellar :any_skip_relocation
    sha256 "593672178e5cacb64a5f002dd21ce4a7cf7e86fa127c03757e36d303f065e8cc" => :sierra
    sha256 "593672178e5cacb64a5f002dd21ce4a7cf7e86fa127c03757e36d303f065e8cc" => :el_capitan
    sha256 "593672178e5cacb64a5f002dd21ce4a7cf7e86fa127c03757e36d303f065e8cc" => :yosemite
  end

  depends_on :emacs => "22.1"
  depends_on "homebrew/emacs/soap-client-emacs" if Emacs.version < Version.create("24.1")

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

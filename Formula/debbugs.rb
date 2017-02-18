require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Debbugs < EmacsFormula
  desc "Emacs library for accessing Debbugs SOAP servers"
  homepage "https://elpa.gnu.org/packages/debbugs.html"
  url "https://elpa.gnu.org/packages/debbugs-0.13.tar"
  sha256 "e17b7db406a33fa365f6bf5e9a81a78130d429fa77ab5ff7e42dc813bf43c309"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a9d120e615b99fc9fb347fb5ea7a704c8c7ae7b3fb585ccf9bd4131b446ed50" => :sierra
    sha256 "4a9d120e615b99fc9fb347fb5ea7a704c8c7ae7b3fb585ccf9bd4131b446ed50" => :el_capitan
    sha256 "4a9d120e615b99fc9fb347fb5ea7a704c8c7ae7b3fb585ccf9bd4131b446ed50" => :yosemite
  end

  depends_on :emacs => "24.1"

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"], "Debbugs.wsdl"
    info.install Dir["*.info"]
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

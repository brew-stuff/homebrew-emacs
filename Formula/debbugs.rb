require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Debbugs < EmacsFormula
  desc "Emacs library for accessing Debbugs SOAP servers"
  homepage "https://elpa.gnu.org/packages/debbugs.html"
  url "https://elpa.gnu.org/packages/debbugs-0.12.tar"
  sha256 "f096b1841c9e10958bef0edaecdcc3b49d3febf54c04995aac112ae84e2391eb"

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

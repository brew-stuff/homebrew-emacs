require File.expand_path("../Homebrew/emacs_formula", __dir__)

class KnowYourHttpWell < EmacsFormula
  desc "HTTP reference lookup in Emacs"
  homepage "https://github.com/for-GET/know-your-http-well"
  url "https://github.com/for-GET/know-your-http-well/archive/v0.5.0.tar.gz"
  sha256 "d26229332d1ebb15cce3970e9185390244f10806986bbaa3e28f7185d0e773f8"
  head "https://github.com/for-GET/know-your-http-well.git"

  depends_on EmacsRequirement

  def install
    cd "emacs" do
      byte_compile Dir["*.el"]
      elisp.install Dir["*.el"], Dir["*.elc"]
    end
    prefix.install "README.md"
    doc.install Dir["*.md"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "know-your-http-well")
      (print (http-status-code "500"))
    EOS
    assert_match "Internal Server Error", shell_output("emacs -Q --batch -l #{testpath}/test.el")
  end
end

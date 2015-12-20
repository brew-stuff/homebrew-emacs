require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class KnowYourHttpWell < EmacsFormula
  desc "HTTP reference lookup in Emacs"
  homepage "https://github.com/for-GET/know-your-http-well"
  url "https://github.com/for-GET/know-your-http-well/archive/v0.4.0.tar.gz"
  sha256 "9f2f69619167679cf770784f129490755d4158a02550d55e01dddfda84831cab"
  head "https://github.com/for-GET/know-your-http-well.git"

  depends_on :emacs

  def install
    cd "emacs" do
      byte_compile Dir["*.el"]
      elisp.install Dir["*.el"], Dir["*.elc"]
    end
    prefix.install "README.md"
    doc.install Dir["*.md"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "know-your-http-well")
      (print (http-status-code "500"))
    EOS
    assert_match "Internal Server Error", shell_output("emacs -Q --batch -l #{testpath}/test.el")
  end
end

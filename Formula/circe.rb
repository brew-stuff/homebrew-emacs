require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Circe < EmacsFormula
  desc "Emacs IRC client"
  homepage "https://github.com/jorgenschaefer/circe"
  url "https://github.com/jorgenschaefer/circe/archive/v2.3.tar.gz"
  sha256 "7f751c3c988f33c49027eb0bf673512499b1266150d1353bf1e5124746f8147f"
  head "https://github.com/jorgenschaefer/circe.git"

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "circe")
      (print circe-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

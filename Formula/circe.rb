require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Circe < EmacsFormula
  desc "Emacs IRC client"
  homepage "https://github.com/jorgenschaefer/circe"
  url "https://github.com/jorgenschaefer/circe/archive/v2.2.tar.gz"
  sha256 "bc756d4adea7a50d7d570ae8fa893c47cd1bfde55c8f91b95213f184f0f2fc08"
  head "https://github.com/jorgenschaefer/circe.git"

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

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

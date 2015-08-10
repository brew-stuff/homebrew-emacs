require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Circe < EmacsFormula
  desc "Emacs IRC client"
  homepage "https://github.com/jorgenschaefer/circe"
  url "https://github.com/jorgenschaefer/circe/archive/v2.0.tar.gz"
  sha256 "c35ca0016a1da8f8c08cc20439a24af82b937b95250711d1c4b2944a3caec45d"
  head "https://github.com/jorgenschaefer/circe.git"

  depends_on :emacs
  depends_on "cask"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    doc.install "README.md", "LICENSE"

    system "scripts/compile"
    (share/"emacs/site-lisp/circe").install Dir["*.el"], Dir["*.elc"]
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'circe)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/circe")
      (load "circe")
      (print circe-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

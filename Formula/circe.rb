require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Circe < EmacsFormula
  desc "Emacs IRC client"
  homepage "https://github.com/jorgenschaefer/circe"
  url "https://github.com/jorgenschaefer/circe/archive/v2.4.tar.gz"
  sha256 "36e5d4a22ba8fce24da222eb7ea4100999f35a0d7a47b3e609942b1e874b9fd1"
  head "https://github.com/jorgenschaefer/circe.git"

  depends_on :emacs
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  depends_on "dunn/emacs/buttercup" => :build

  def install
    system Formula["dunn/emacs/buttercup"].bin/"buttercup", "-L", "."

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

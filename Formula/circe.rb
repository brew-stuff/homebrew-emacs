require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Circe < EmacsFormula
  desc "Emacs IRC client"
  homepage "https://github.com/jorgenschaefer/circe"
  url "https://github.com/jorgenschaefer/circe/archive/v2.5.tar.gz"
  sha256 "c9d26e5aab840f41526166dc89fce5421e91c250b58620f26a2161ef0c5c1a75"
  head "https://github.com/jorgenschaefer/circe.git"

  depends_on EmacsRequirement
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
      (add-to-list 'load-path "#{Formula["dunn/emacs/cl-lib"].opt_elisp}")
      (load "circe")
      (print circe-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

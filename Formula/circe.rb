require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Circe < EmacsFormula
  desc "Emacs IRC client"
  homepage "https://github.com/jorgenschaefer/circe"
  url "https://github.com/jorgenschaefer/circe/archive/v1.5.tar.gz"
  sha256 "a67fc53113de9af919ba1da5906d86eecd5418fd3e53793c266a44d4f214a284"

  head do
    url "https://github.com/jorgenschaefer/circe.git"
    depends_on "cask"
  end

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    doc.install "README.md", "LICENSE"

    if build.stable?
      Dir.chdir "lisp"
      byte_compile Dir["*.el"]
    else
      inreplace "scripts/compile", "find -name", "find . -name"
      system "scripts/compile"
    end
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

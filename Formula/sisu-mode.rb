require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SisuMode < EmacsFormula
  desc "Emacs major mode for editing SiSU markup"
  homepage "http://elpa.gnu.org/packages/sisu-mode.html"
  url "http://elpa.gnu.org/packages/sisu-mode-7.1.8.el"
  sha256 "d282c04aa6cdee1e7726e5c0b3f002d22507181f90272adb69e1d99f8937fa8b"

  depends_on EmacsRequirement

  def install
    mv "sisu-mode-#{version}.el", "sisu-mode.el"
    byte_compile "sisu-mode.el"
    elisp.install "sisu-mode.el", "sisu-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "sisu-mode")
      (sisu-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

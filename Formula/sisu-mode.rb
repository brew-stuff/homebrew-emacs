require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SisuMode < EmacsFormula
  desc "Emacs major mode for editing SiSU markup"
  homepage "http://elpa.gnu.org/packages/sisu-mode.html"
  url "http://elpa.gnu.org/packages/sisu-mode-3.0.3.el"
  sha256 "7968afd4acddd75a79cff197fe494b86e7fe5b3840005fd370a3f4d1a383c92b"

  depends_on :emacs

  def install
    mv "sisu-mode-#{version}.el", "sisu-mode.el"
    byte_compile "sisu-mode.el"
    (share/"emacs/site-lisp/sisu-mode").install "sisu-mode.el",
                                                "sisu-mode.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'sisu-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "sisu-mode")
      (sisu-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

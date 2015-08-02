require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SmlMode < EmacsFormula
  desc "Emacs major mode for editing Standard ML"
  homepage "http://elpa.gnu.org/packages/sml-mode.html"
  url "http://elpa.gnu.org/packages/sml-mode-6.7.el"
  sha256 "3db9673b7c23e3ee58d8f0e748871700125fa0e44cdf14754a3ed6787aaf2d10"

  depends_on :emacs => "24.1"

  def install
    mv "sml-mode-#{version}.el", "sml-mode.el"
    byte_compile "sml-mode.el"
    (share/"emacs/site-lisp/sml-mode").install "sml-mode.el",
                                               "sml-mode.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'sml-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/sml-mode")
      (load "sml-mode")
      (sml-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

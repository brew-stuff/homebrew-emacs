require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class OmnMode < EmacsFormula
  desc "Emacs major mode for the OWL Manchester Notation"
  homepage "http://elpa.gnu.org/packages/omn-mode.html"
  url "http://elpa.gnu.org/packages/omn-mode-1.0.el"
  sha256 "65d1293e6ffdc53cc8f617be9a84d2ee1a3aa4725aea93dac2c4b55ea3606a12"

  depends_on :emacs

  def install
    mv "omn-mode-#{version}.el", "omn-mode.el"
    byte_compile "omn-mode.el"
    (share/"emacs/site-lisp/omn-mode").install "omn-mode.el",
                                               "omn-mode.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'omn-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "omn-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

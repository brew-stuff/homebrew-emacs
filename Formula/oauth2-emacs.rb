require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Oauth2Emacs < EmacsFormula
  desc "Emacs library for OAuth 2.0"
  homepage "http://elpa.gnu.org/packages/oauth2.html"
  url "http://elpa.gnu.org/packages/oauth2-0.10.el"
  sha256 "ca7ae1ca38cc2ea6c541e555a651308596dd2de8ad969638f6e03684d6aa9d66"

  depends_on :emacs

  def install
    mv "oauth2-#{version}.el", "oauth2.el"
    byte_compile "oauth2.el"
    (share/"emacs/site-lisp/oauth2").install "oauth2.el",
                                             "oauth2.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "oauth2")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

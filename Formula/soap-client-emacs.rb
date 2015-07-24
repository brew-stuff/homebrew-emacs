require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SoapClientEmacs < EmacsFormula
  desc "Emacs SOAP client"
  homepage "https://github.com/alex-hhh/emacs-soap-client"
  head "https://github.com/alex-hhh/emacs-soap-client.git"

  depends_on :emacs

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/soap-client").install Dir["*.el"],
                                                  Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "soap-client")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

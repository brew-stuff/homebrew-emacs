require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SoapClientEmacs < EmacsFormula
  desc "Emacs SOAP client"
  homepage "https://github.com/alex-hhh/emacs-soap-client"
  url "https://github.com/alex-hhh/emacs-soap-client/archive/3.0.0.tar.gz"
  sha256 "804d291b0875da8b15ff82246926cbef8f1e8b529f61c1381e442b9ff25b842b"
  head "https://github.com/alex-hhh/emacs-soap-client.git"

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/soap-client").install Dir["*.el"],
                                                  Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp")
      (load "soap-client")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

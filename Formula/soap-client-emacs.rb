require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SoapClientEmacs < EmacsFormula
  desc "Emacs SOAP client"
  homepage "https://github.com/alex-hhh/emacs-soap-client"
  url "https://github.com/alex-hhh/emacs-soap-client/archive/3.1.2.tar.gz"
  sha256 "0c69d65a8cdc4aa5fad903c3ab7a752058d4ea5d7f3a8ff37ed92ecf40df95ac"
  head "https://github.com/alex-hhh/emacs-soap-client.git"

  depends_on :emacs => "23.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/cl-lib"].opt_elisp}")
      (load "soap-client")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

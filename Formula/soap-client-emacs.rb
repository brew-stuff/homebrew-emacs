require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SoapClientEmacs < EmacsFormula
  desc "Emacs SOAP client"
  homepage "https://github.com/alex-hhh/emacs-soap-client"
  url "https://github.com/alex-hhh/emacs-soap-client/archive/3.0.2.tar.gz"
  sha256 "fed577c8244f5a2102ecea440d8e3646e50d2c1837f9475142e2380ec35589d1"
  head "https://github.com/alex-hhh/emacs-soap-client.git"

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "soap-client")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

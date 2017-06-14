require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SoapClientEmacs < EmacsFormula
  desc "Emacs SOAP client"
  homepage "https://github.com/alex-hhh/emacs-soap-client"
  url "https://github.com/alex-hhh/emacs-soap-client/archive/3.1.3.tar.gz"
  sha256 "51815efc543380e9c237c764dd24cf904a2dfc27ec7f1b226c6befa6c3b83c59"
  head "https://github.com/alex-hhh/emacs-soap-client.git"

  depends_on :emacs => "23.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile "jira2.el", "soap-client.el", "soap-inspect.el"

    elisp.install "jira2.el", "soap-client.el", "soap-inspect.el",
                  "jira2.elc", "soap-client.elc", "soap-inspect.elc"
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

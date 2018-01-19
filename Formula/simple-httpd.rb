require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SimpleHttpd < EmacsFormula
  desc "Extensible Emacs HTTP 1.1 server"
  homepage "https://github.com/skeeto/emacs-web-server"
  url "https://github.com/skeeto/emacs-web-server/archive/1.4.6.tar.gz"
  sha256 "1908f12864c3cfa3997859e4e4caf78cfab59d925ca8516ae898485be3802707"
  head "https://github.com/skeeto/emacs-web-server.git"

  depends_on EmacsRequirement
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    ert_run_tests "simple-httpd-test.el"
    byte_compile "simple-httpd.el"
    (share/"emacs/site-lisp/simple-httpd").install "simple-httpd.el",
                                                   "simple-httpd.elc"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'simple-httpd)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/simple-httpd")
      (load "simple-httpd")
      (setq httpd-root "#{testpath}")
      (httpd-start)
      (httpd-stop)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SkewerMode < EmacsFormula
  desc "Emacs mode for live web development"
  homepage "https://github.com/skeeto/skewer-mode"
  url "https://github.com/skeeto/skewer-mode/archive/1.6.2.tar.gz"
  sha256 "a0b78e77ecbf26320ee407a93e68bb5328e967b6ff0fff3531490249cef8571e"
  head "https://github.com/skeeto/skewer-mode.git"

  depends_on :emacs => "24.3"
  depends_on "homebrew/emacs/js2-mode"
  depends_on "homebrew/emacs/simple-httpd"

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/skewer-mode").install Dir["*.el"], Dir["*.elc"], Dir["*.js"], Dir["*.html"]
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'skewer-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/skewer-mode")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/simple-httpd"].share}/emacs/site-lisp/simple-httpd")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/js2-mode"].share}/emacs/site-lisp/js2-mode")
      (load "skewer-mode")
      (run-skewer)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

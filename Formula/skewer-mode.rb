require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SkewerMode < EmacsFormula
  desc "Emacs mode for live web development"
  homepage "https://github.com/skeeto/skewer-mode"
  url "https://github.com/skeeto/skewer-mode/archive/1.7.0.tar.gz"
  sha256 "a824879872985d9fad1a1aa57c965b03d61106b33e1ff7102991a8a6d80a05ea"
  head "https://github.com/skeeto/skewer-mode.git"

  depends_on EmacsRequirement => "24.3"
  depends_on "dunn/emacs/js2-mode"
  depends_on "dunn/emacs/simple-httpd"

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"], Dir["*.js"], Dir["*.html"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/skewer-mode")
      (add-to-list 'load-path "#{Formula["dunn/emacs/simple-httpd"].opt_share}/emacs/site-lisp/simple-httpd")
      (add-to-list 'load-path "#{Formula["dunn/emacs/js2-mode"].opt_share}/emacs/site-lisp/js2-mode")
      (load "skewer-mode")
      (run-skewer)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

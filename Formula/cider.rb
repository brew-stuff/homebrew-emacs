require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Cider < EmacsFormula
  desc "Clojure IDE for Emacs"
  homepage "https://github.com/clojure-emacs/cider"
  url "https://github.com/clojure-emacs/cider/archive/v0.9.1.tar.gz"
  sha256 "e2ac1e26a936fe7942ebabb96c720d792b8e77a692d7ab445b13da2fa058b233"
  head "https://github.com/clojure-emacs/cider.git"

  depends_on :emacs => "24.3"
  depends_on "dunn/emacs/clojure-mode"
  depends_on "dunn/emacs/dash"
  depends_on "dunn/emacs/pkg-info"
  depends_on "dunn/emacs/queue-emacs"

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/cider").install Dir["*.el"], Dir["*.elc"]
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'cider)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/cider")
      (add-to-list 'load-path "#{Formula["dunn/emacs/dash"].share}/emacs/site-lisp/dash")
      (add-to-list 'load-path "#{Formula["dunn/emacs/clojure-mode"].share}/emacs/site-lisp/clojure-mode")
      (add-to-list 'load-path "#{Formula["dunn/emacs/queue-emacs"].share}/emacs/site-lisp/queue")
      (load "cider")
      (print cider-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Cider < EmacsFormula
  desc "Clojure IDE for Emacs"
  homepage "https://github.com/clojure-emacs/cider"
  url "https://github.com/clojure-emacs/cider/archive/v0.9.1.tar.gz"
  sha256 "e2ac1e26a936fe7942ebabb96c720d792b8e77a692d7ab445b13da2fa058b233"
  head "https://github.com/clojure-emacs/cider.git"

  depends_on :emacs => "24.3"
  depends_on "homebrew/emacs/clojure-mode"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/pkg-info"
  depends_on "homebrew/emacs/queue-emacs"
  depends_on "homebrew/emacs/seq"
  depends_on "homebrew/emacs/spinner-emacs"

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/clojure-mode"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/queue-emacs"].opt_elisp}")
      (load "cider")
      (print cider-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

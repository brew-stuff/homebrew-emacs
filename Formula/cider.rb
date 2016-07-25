require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Cider < EmacsFormula
  desc "Clojure IDE for Emacs"
  homepage "https://github.com/clojure-emacs/cider"
  url "https://github.com/clojure-emacs/cider/archive/v0.13.0.tar.gz"
  sha256 "5a73bccbaa705f2f66dc27bfdc7030a3f3262b4686b9f14d83a0a1134f910f8e"
  head "https://github.com/clojure-emacs/cider.git"

  depends_on :emacs => "24.3"
  depends_on :java => ["1.7+", :run]

  depends_on "homebrew/emacs/clojure-mode"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/pkg-info"
  depends_on "homebrew/emacs/queue-emacs"
  depends_on "homebrew/emacs/seq" if Emacs.version < 25
  depends_on "homebrew/emacs/spinner-emacs"

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/clojure-mode"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/pkg-info"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/queue-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/seq"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/spinner-emacs"].opt_elisp}")
      (load "cider")
      (print cider-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

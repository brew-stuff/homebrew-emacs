require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Cider < EmacsFormula
  desc "Clojure IDE for Emacs"
  homepage "https://github.com/clojure-emacs/cider"
  url "https://github.com/clojure-emacs/cider/archive/v0.14.0.tar.gz"
  sha256 "7dafbbc43aa36c84a4fba72d9a8a25a7cc98dd0161aaeb038c576fc0c65e759c"
  head "https://github.com/clojure-emacs/cider.git"

  depends_on :emacs => "24.3"
  depends_on :java => ["1.7+", :run]

  depends_on "dunn/emacs/clojure-mode"
  depends_on "dunn/emacs/dash-emacs"
  depends_on "dunn/emacs/pkg-info"
  depends_on "dunn/emacs/queue-emacs"
  depends_on "dunn/emacs/seq" if Emacs.version < Version.create("25")
  depends_on "dunn/emacs/spinner-emacs"

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/clojure-mode"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/pkg-info"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/queue-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/seq"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/spinner-emacs"].opt_elisp}")
      (load "cider")
      (print cider-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

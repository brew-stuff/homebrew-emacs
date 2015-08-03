require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ClojureMode < EmacsFormula
  desc "Emacs major mode for Clojure"
  homepage "https://github.com/clojure-emacs/clojure-mode"
  url "https://github.com/clojure-emacs/clojure-mode/archive/4.1.0.tar.gz"
  sha256 "05105cbeb0c1db47c0be0835de9afde6be76a83ea32e06bbcc07dcd4ac72cb25"
  head "https://github.com/clojure-emacs/clojure-mode.git"

  option "with-inf", "Build with the \"inferior\" REPL"

  depends_on :emacs => "24.3"
  depends_on "cask"

  resource "inf" do
    url "https://github.com/clojure-emacs/inf-clojure/archive/v1.2.0.tar.gz"
    sha256 "1dd45cee8d263051c09428e07b6c2cb010914b00ff493cdf532dd28d7832ac1c"
  end

  def install
    system "make", "test", "CASK=#{Formula["cask"].bin}/cask"
    system "make", "compile", "CASK=#{Formula["cask"].bin}/cask"
    (share/"emacs/site-lisp/clojure-mode").install Dir["*.el"],
                                                   Dir["*.elc"]
    doc.install "README.md"

    if build.with? "inf"
      resource("inf").stage do
        (share/"emacs/site-lisp/clojure-mode").install "inf-clojure.el"
      end
    end
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'clojure-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/clojure-mode")
      (load "clojure-mode")
      (print clojure-mode-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

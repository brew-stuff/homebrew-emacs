require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Helm < EmacsFormula
  desc "Emacs completion and selection narrowing framework"
  homepage "https://emacs-helm.github.io/helm/"
  url "https://github.com/emacs-helm/helm/archive/v2.5.4.tar.gz"
  sha256 "9a4c6bdd51d9d9100fc180e865447f045a63cc23b1a7fe525261ee6d54714243"
  head "https://github.com/emacs-helm/helm.git"

  bottle :disable

  depends_on :emacs => "24.3"
  depends_on "dunn/emacs/async-emacs"

  def install
    system "make"
    puts "hello"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/helm")
      (load "helm-config")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

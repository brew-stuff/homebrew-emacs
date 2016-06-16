require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Helm < EmacsFormula
  desc "Emacs completion and selection narrowing framework"
  homepage "https://emacs-helm.github.io/helm/"
  url "https://github.com/emacs-helm/helm/archive/v1.9.7.tar.gz"
  sha256 "3b416e270f43f5488145d5c583bf1da63a8ab50c8b9ad2bb33ddea4d728c2f85"
  head "https://github.com/emacs-helm/helm.git"

  depends_on :emacs => "24.3"
  depends_on "homebrew/emacs/async-emacs"

  def install
    system "make"
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

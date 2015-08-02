require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Helm < EmacsFormula
  desc "Emacs incremental completion and selection narrowing framework"
  homepage "https://emacs-helm.github.io/helm/"
  url "https://github.com/emacs-helm/helm/archive/v1.7.5.tar.gz"
  sha256 "50757fdaa6063e4838cca08f78545004e45bd448461aae53b0a87d220995f2c2"
  head "https://github.com/emacs-helm/helm.git"

  depends_on :emacs => "24.3"
  depends_on "dunn/emacs/async-emacs"

  def install
    system "make"
    (share/"emacs/site-lisp/helm").install Dir["*.el"],
                                           Dir["*.elc"]
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'helm-config)
    (global-set-key (kbd "M-x") 'helm-M-x)
  EOS
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

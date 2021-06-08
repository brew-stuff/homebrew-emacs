require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Helm < EmacsFormula
  desc "Emacs completion and selection narrowing framework"
  homepage "https://emacs-helm.github.io/helm/"
  url "https://github.com/emacs-helm/helm/archive/v2.8.4.tar.gz"
  sha256 "0d5616c3582377eb54f6d15a0822fdc1c46ce48b46d5b1e394c1878905b715b5"
  head "https://github.com/emacs-helm/helm.git"

  bottle :disable

  depends_on EmacsRequirement => "24.3"
  depends_on "dunn/emacs/async-emacs"

  def install
    system "make", "ASYNC_ELPA_DIR=#{Formula["dunn/emacs/async-emacs"].opt_elisp}"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/async-emacs"].opt_elisp}")
      (load "helm-config")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

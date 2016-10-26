require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Helm < EmacsFormula
  desc "Emacs completion and selection narrowing framework"
  homepage "https://emacs-helm.github.io/helm/"
  url "https://github.com/emacs-helm/helm/archive/v2.3.1.tar.gz"
  sha256 "9829ca84d618cc50384e5baf486c19593d4aef8770f29eae9003fec18bdd3aca"
  head "https://github.com/emacs-helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "30eaf9e65dd274440eaabd8f3f8055a15aa6e3a0c11caf40b85d7bbd765272f5" => :sierra
    sha256 "30eaf9e65dd274440eaabd8f3f8055a15aa6e3a0c11caf40b85d7bbd765272f5" => :el_capitan
    sha256 "30eaf9e65dd274440eaabd8f3f8055a15aa6e3a0c11caf40b85d7bbd765272f5" => :yosemite
  end

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

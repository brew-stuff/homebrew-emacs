require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Helm < EmacsFormula
  desc "Emacs completion and selection narrowing framework"
  homepage "https://emacs-helm.github.io/helm/"
  url "https://github.com/emacs-helm/helm/archive/v2.4.0.tar.gz"
  sha256 "46579186942a5c20070553e40ef26accce48910cf07e944b0064ad72a61f2f7d"
  head "https://github.com/emacs-helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "73db7d57cda9e73bb1cf45bd65078f61c2f9f9d2d20a11ea8d67b9c88b0d4ddf" => :sierra
    sha256 "ffc778a3b20cbe68ada307b462f5d0cf3177754762cffde8ef68bb50a04ea2af" => :el_capitan
    sha256 "ffc778a3b20cbe68ada307b462f5d0cf3177754762cffde8ef68bb50a04ea2af" => :yosemite
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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Helm < EmacsFormula
  desc "Emacs completion and selection narrowing framework"
  homepage "https://emacs-helm.github.io/helm/"
  url "https://github.com/emacs-helm/helm/archive/v2.2.0.tar.gz"
  sha256 "2f51f262ff07940e25f7c49c56f6ff214e0d41c5bd56516fe148c0178fe8cee6"
  head "https://github.com/emacs-helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "16cea6024bd9670d50610624ac5a63285ab7b8f34c48e17b4ead9ccff82e615a" => :sierra
    sha256 "16cea6024bd9670d50610624ac5a63285ab7b8f34c48e17b4ead9ccff82e615a" => :el_capitan
    sha256 "16cea6024bd9670d50610624ac5a63285ab7b8f34c48e17b4ead9ccff82e615a" => :yosemite
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

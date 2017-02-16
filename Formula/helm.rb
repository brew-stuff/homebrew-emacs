require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Helm < EmacsFormula
  desc "Emacs completion and selection narrowing framework"
  homepage "https://emacs-helm.github.io/helm/"
  url "https://github.com/emacs-helm/helm/archive/v2.5.0.tar.gz"
  sha256 "6615237120270008a422a93b6db606e0a602c8a0244221214338c5a5db4745ed"
  head "https://github.com/emacs-helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfa745ae5d2b159d19c7fc0b3f2afc3a5eb7ac8006733e50e3911b172d413c2d" => :sierra
    sha256 "838b1bf0a7cb4198cd34d31a313cdec549ece7c357bc2965eca6d6b20abd81ce" => :el_capitan
    sha256 "838b1bf0a7cb4198cd34d31a313cdec549ece7c357bc2965eca6d6b20abd81ce" => :yosemite
  end

  depends_on :emacs => "24.3"
  depends_on "dunn/emacs/async-emacs"

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

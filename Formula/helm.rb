require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Helm < EmacsFormula
  desc "Emacs completion and selection narrowing framework"
  homepage "https://emacs-helm.github.io/helm/"
  url "https://github.com/emacs-helm/helm/archive/v2.3.0.tar.gz"
  sha256 "6f49ec7a9aefab47f461cb86cd6711a288f8c64a8e89638b9866e6e31e397f63"
  head "https://github.com/emacs-helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac94402c809d040d9af8713fb3bc117d063d12a7482deddb1a99da73ef9f923d" => :sierra
    sha256 "ac94402c809d040d9af8713fb3bc117d063d12a7482deddb1a99da73ef9f923d" => :el_capitan
    sha256 "ac94402c809d040d9af8713fb3bc117d063d12a7482deddb1a99da73ef9f923d" => :yosemite
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

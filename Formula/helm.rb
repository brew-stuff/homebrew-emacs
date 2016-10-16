require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Helm < EmacsFormula
  desc "Emacs completion and selection narrowing framework"
  homepage "https://emacs-helm.github.io/helm/"
  url "https://github.com/emacs-helm/helm/archive/v2.3.0.tar.gz"
  sha256 "6f49ec7a9aefab47f461cb86cd6711a288f8c64a8e89638b9866e6e31e397f63"
  head "https://github.com/emacs-helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5be7e698d81d8ccc3439d950fe83538dd49a8eccbd0fcb1487a21370f17efeb4" => :sierra
    sha256 "5be7e698d81d8ccc3439d950fe83538dd49a8eccbd0fcb1487a21370f17efeb4" => :el_capitan
    sha256 "5be7e698d81d8ccc3439d950fe83538dd49a8eccbd0fcb1487a21370f17efeb4" => :yosemite
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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Helm < EmacsFormula
  desc "Emacs completion and selection narrowing framework"
  homepage "https://emacs-helm.github.io/helm/"
  url "https://github.com/emacs-helm/helm/archive/v2.1.0.tar.gz"
  sha256 "546e32dffa9c90142b6e45e168ad0e9fa753232b8994a8e6649e5c7fd255be9e"
  head "https://github.com/emacs-helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0288de17114d2cb79f37dcb1a81185d56e5e7646c48419a8043158a0da093027" => :sierra
    sha256 "0288de17114d2cb79f37dcb1a81185d56e5e7646c48419a8043158a0da093027" => :el_capitan
    sha256 "0288de17114d2cb79f37dcb1a81185d56e5e7646c48419a8043158a0da093027" => :yosemite
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

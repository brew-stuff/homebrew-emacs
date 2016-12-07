require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Helm < EmacsFormula
  desc "Emacs completion and selection narrowing framework"
  homepage "https://emacs-helm.github.io/helm/"
  url "https://github.com/emacs-helm/helm/archive/v2.3.3.tar.gz"
  sha256 "9bf68cc94ddbe667f4a14c2e0abb5a645ffa24959b186c72c25d7c621f804eef"
  head "https://github.com/emacs-helm/helm.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "72bdd9254528483c4eec0e31d5127c2e4d9a008277f61d381ff7b07aa2527dfc" => :sierra
    sha256 "72bdd9254528483c4eec0e31d5127c2e4d9a008277f61d381ff7b07aa2527dfc" => :el_capitan
    sha256 "72bdd9254528483c4eec0e31d5127c2e4d9a008277f61d381ff7b07aa2527dfc" => :yosemite
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

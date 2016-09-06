require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Olivetti < EmacsFormula
  desc "Emacs minor mode for distraction-free writing"
  homepage "https://github.com/rnkn/olivetti"
  url "https://github.com/rnkn/olivetti/archive/v.1.5.5.tar.gz"
  sha256 "abae136d36a3880dc077dbfca04ff37e3966d11f914e7a750b4828c0e81309a9"
  head "https://github.com/rnkn/olivetti.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "60046071268bb681034986943f56e00348e6d7db78f1283e457da0a4dd2f9b88" => :el_capitan
    sha256 "8e86617a7be9d316f719de8fbed8947fea33d6f96334ff79b6fe9e8a19e1ebe3" => :yosemite
    sha256 "8e86617a7be9d316f719de8fbed8947fea33d6f96334ff79b6fe9e8a19e1ebe3" => :mavericks
  end

  depends_on :emacs => "24.4"

  def install
    byte_compile "olivetti.el"
    elisp.install "olivetti.el", "olivetti.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/olivetti")
      (load "olivetti")
      (olivetti-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Olivetti < EmacsFormula
  desc "Emacs minor mode for distraction-free writing"
  homepage "https://github.com/rnkn/olivetti"
  url "https://github.com/rnkn/olivetti/archive/v1.5.6.tar.gz"
  sha256 "06fb7f68bf07710cf59beb16c7a877b0504ab2809f227254beeeb933caf8638a"
  head "https://github.com/rnkn/olivetti.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0fad2ae9934cfcf128c817d05432fb838bad006da13fa5df6ab57314c621a4a" => :el_capitan
    sha256 "de690d9fafca4739d01a1b7970e2fbbb4bb77df4bb989c87c28f827ad15c680b" => :yosemite
    sha256 "de690d9fafca4739d01a1b7970e2fbbb4bb77df4bb989c87c28f827ad15c680b" => :mavericks
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

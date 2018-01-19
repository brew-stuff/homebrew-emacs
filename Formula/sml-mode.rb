require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SmlMode < EmacsFormula
  desc "Emacs major mode for editing Standard ML"
  homepage "https://elpa.gnu.org/packages/sml-mode.html"
  url "https://elpa.gnu.org/packages/sml-mode-6.7.el"
  sha256 "3db9673b7c23e3ee58d8f0e748871700125fa0e44cdf14754a3ed6787aaf2d10"

  bottle do
    cellar :any_skip_relocation
    sha256 "0bbef293efc508f9c36deffcca323895aa4fd4d2da21527659d4e82bcaf389bf" => :sierra
    sha256 "0bbef293efc508f9c36deffcca323895aa4fd4d2da21527659d4e82bcaf389bf" => :el_capitan
    sha256 "0bbef293efc508f9c36deffcca323895aa4fd4d2da21527659d4e82bcaf389bf" => :yosemite
  end

  depends_on EmacsRequirement => "24.1"

  def install
    mv "sml-mode-#{version}.el", "sml-mode.el"
    byte_compile "sml-mode.el"
    elisp.install "sml-mode.el", "sml-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "sml-mode")
      (sml-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

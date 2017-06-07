require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Nlinum < EmacsFormula
  desc "Emacs mode for displaying line numbers in the margin"
  homepage "https://elpa.gnu.org/packages/nlinum.html"
  url "https://elpa.gnu.org/packages/nlinum-1.7.el"
  sha256 "9f86c20724e3bd7bb393104351cd0982ae885e41a9985df9d84d27d1d46a8162"

  bottle :disable

  depends_on :emacs => "23.1"

  def install
    mv "nlinum-#{version}.el", "nlinum.el"
    byte_compile "nlinum.el"
    elisp.install "nlinum.el", "nlinum.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "nlinum")
      (nlinum-mode)
      (print nlinum--width)
    EOS
    assert_equal "2", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

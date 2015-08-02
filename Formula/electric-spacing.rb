require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ElectricSpacing < EmacsFormula
  desc "Emacs minor mode for smart spacing around operators"
  homepage "http://elpa.gnu.org/packages/electric-spacing.html"
  url "http://elpa.gnu.org/packages/electric-spacing-5.0.el"
  sha256 "db3be647b3573da463377711d7b7bbb91df85f3e9393afbfa41259f009da66ca"

  depends_on :emacs

  def install
    mv "electric-spacing-#{version}.el", "electric-spacing.el"
    byte_compile "electric-spacing.el"
    (share/"emacs/site-lisp/electric-spacing").install "electric-spacing.el",
                                                       "electric-spacing.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'electric-spacing)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/electric-spacing")
      (load "electric-spacing")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

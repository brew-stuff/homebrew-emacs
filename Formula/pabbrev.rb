require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Pabbrev < EmacsFormula
  desc "Predictive abbreviation expansion for Emacs"
  homepage "https://github.com/phillord/pabbrev"
  url "http://elpa.gnu.org/packages/pabbrev-4.2.1.el"
  sha256 "b0bb2a370b626d09a43b7159080ac95ca6239bf9dcccc35fbc0ef960665365a7"
  head "https://github.com/phillord/pabbrev.git"

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    mv "pabbrev-#{version}.el", "pabbrev.el" if build.stable?

    byte_compile "pabbrev.el"
    elisp.install "pabbrev.el", "pabbrev.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "pabbrev")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

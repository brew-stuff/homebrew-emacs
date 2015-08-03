require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Pabbrev < EmacsFormula
  desc "Predictive abbreviation expansion for Emacs"
  homepage "https://github.com/phillord/pabbrev"
  url "http://elpa.gnu.org/packages/pabbrev-4.2.el"
  sha256 "530118458c1340e3a48b8efe0f365aa360c7764c3d39d8ae215cdeb3078ddef5"
  head "https://github.com/phillord/pabbrev.git"

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    mv "pabbrev-#{version}.el", "pabbrev.el" if build.stable?

    byte_compile "pabbrev.el"
    (share/"emacs/site-lisp/pabbrev").install "pabbrev.el",
                                              "pabbrev.elc"
    doc.install "README.md" if build.head?
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'pabbrev)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/pabbrev")
      (load "pabbrev")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

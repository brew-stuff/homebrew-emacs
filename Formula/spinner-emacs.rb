require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SpinnerEmacs < EmacsFormula
  desc "Emacs library for spinners and progress bars"
  homepage "https://github.com/Malabarba/spinner.el"
  url "http://elpa.gnu.org/packages/spinner-1.3.1.el"
  sha256 "06e12c872be3202f02aa0db9c8336758075f6faeca23014a52b610534b211854"
  head "https://github.com/Malabarba/spinner.el.git"

  depends_on :emacs

  def install
    mv "spinner-#{version}.el", "spinner.el" if build.stable?
    byte_compile "spinner.el"
    (share/"emacs/site-lisp/spinner").install "spinner.el",
                                              "spinner.elc"
    doc.install "README.org" if build.head?
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "spinner")
      (spinner-start)
      (spinner-stop)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

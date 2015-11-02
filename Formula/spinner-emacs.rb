require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SpinnerEmacs < EmacsFormula
  desc "Emacs library for spinners and progress bars"
  homepage "https://github.com/Malabarba/spinner.el"
  url "http://elpa.gnu.org/packages/spinner-1.4.el"
  sha256 "6eb561821f9a220bb311206bd75e40cb5d12c04ab586b1bc1f48356817449d48"
  head "https://github.com/Malabarba/spinner.el.git"

  depends_on :emacs

  def install
    mv "spinner-#{version}.el", "spinner.el" if build.stable?
    byte_compile "spinner.el"
    elisp.install "spinner.el", "spinner.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "spinner")
      (spinner-start)
      (spinner-stop)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

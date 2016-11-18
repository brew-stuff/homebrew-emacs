require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SpinnerEmacs < EmacsFormula
  desc "Emacs library for spinners and progress bars"
  homepage "https://github.com/Malabarba/spinner.el"
  url "https://elpa.gnu.org/packages/spinner-1.7.3.el"
  sha256 "0daa8d7ee2b798045c3868c0a5f32fce5f42a57b4fecfd7408bcae666b0d77a6"
  head "https://github.com/Malabarba/spinner.el.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f21644bdfb2b8f3a8efbf95e5d7bbe6e8cf8fdfb38b9fc40ea32f059242a7b2d" => :sierra
    sha256 "f21644bdfb2b8f3a8efbf95e5d7bbe6e8cf8fdfb38b9fc40ea32f059242a7b2d" => :el_capitan
    sha256 "f21644bdfb2b8f3a8efbf95e5d7bbe6e8cf8fdfb38b9fc40ea32f059242a7b2d" => :yosemite
  end

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

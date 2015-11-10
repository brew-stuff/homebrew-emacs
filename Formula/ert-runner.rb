require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ErtRunner < EmacsFormula
  desc "Opinionated ERT testing workflow"
  homepage "https://github.com/rejeep/ert-runner.el"
  url "https://github.com/rejeep/ert-runner.el/archive/v0.7.0.tar.gz"
  sha256 "973f3abbbcb6fc51cde37fce1bc4fdd43da401c62e33445f27caa49826b3a798"
  head "https://github.com/rejeep/ert-runner.el.git"

  depends_on :emacs
  depends_on "cask"
  depends_on "homebrew/emacs/ansi-emacs"
  depends_on "homebrew/emacs/commander-emacs"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/f"
  depends_on "homebrew/emacs/s"
  depends_on "homebrew/emacs/shut-up"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]

    inreplace "bin/ert-runner", "ERT_RUNNER=\"$(dirname $(dirname $0))/ert-runner.el\"",
                                "ERT_RUNNER=#{elisp}/ert-runner.el"
    bin.install "bin/ert-runner"
  end

  test do
    (testpath/"Cask").write <<-EOS.undent
      (source gnu)
      (source melpa-stable)
      (depends-on "ansi")
      (depends-on "cl-lib")
      (depends-on "commander")
      (depends-on "dash")
      (depends-on "f")
      (depends-on "s")
      (depends-on "shut-up")
    EOS
    system Formula["cask"].bin/"cask", "install"
    system Formula["cask"].bin/"cask", "exec", "ert-runner", "init", "Brewin"
    File.exist? "test/Brewin-test.el"
  end
end

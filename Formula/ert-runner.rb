require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ErtRunner < EmacsFormula
  desc "Opinionated ERT testing workflow"
  homepage "https://github.com/rejeep/ert-runner.el"
  url "https://github.com/rejeep/ert-runner.el/archive/v0.7.0.tar.gz"
  sha256 "973f3abbbcb6fc51cde37fce1bc4fdd43da401c62e33445f27caa49826b3a798"
  head "https://github.com/rejeep/ert-runner.el.git"
  revision 1

  depends_on :emacs
  depends_on "homebrew/emacs/ansi-emacs"
  depends_on "homebrew/emacs/commander-emacs"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/f-emacs"
  depends_on "homebrew/emacs/s-emacs"
  depends_on "homebrew/emacs/shut-up"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile Dir["*.el"], Dir["reporters/*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"], "reporters"

    load_paths = %w[ansi-emacs commander-emacs dash-emacs f-emacs s-emacs shut-up].map do |dep|
      "--directory " + Formula["homebrew/emacs/#{dep}"].opt_elisp
    end

    inreplace "bin/ert-runner" do |s|
      s.gsub! "ERT_RUNNER=\"$(dirname $(dirname $0))/ert-runner.el\"",
              "ERT_RUNNER=#{elisp}/ert-runner.el"
      s.gsub! "--load", "--batch #{load_paths.join(" ")} --load"
      s.gsub! "--script", "--batch #{load_paths.join(" ")} --load"
    end
    bin.install "bin/ert-runner"
  end

  test do
    system bin/"ert-runner", "init", "Brewin"
    File.exist? "test/Brewin-test.el"
  end
end

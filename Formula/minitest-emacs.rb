require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class MinitestEmacs < EmacsFormula
  desc "Minor mode for interacting with minitest within Emacs"
  homepage "https://github.com/arthurnn/minitest-emacs"
  url "https://github.com/arthurnn/minitest-emacs/archive/v0.8.0.tar.gz"
  sha256 "1ac7776f45f837dc522d384ec741fdfc2ca6b01c0757fc3479a607bdff3c4bb7"
  head "https://github.com/arthurnn/minitest-emacs.git"

  bottle :disable

  depends_on EmacsRequirement
  depends_on "dunn/emacs/dash-emacs"

  # https://github.com/arthurnn/minitest-emacs/pull/37
  # depends_on "dunn/emacs/f-emacs" => :build
  # depends_on "dunn/emacs/el-mock" => :build

  def install
    # ert_run_tests "test/minitest-unit-test.el"

    byte_compile "minitest.el"
    elisp.install "minitest.el", "minitest.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/dash-emacs"].opt_elisp}")
      (load "minitest")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

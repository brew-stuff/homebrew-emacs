require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class RspecMode < EmacsFormula
  desc "RSpec minor mode for Emacs"
  homepage "https://github.com/pezra/rspec-mode"
  url "https://github.com/pezra/rspec-mode/archive/v1.11.tar.gz"
  sha256 "7cdfe79434f14ed70becfe65509932da7777c138d63b0ccca3d68452743d0ac8"
  head "https://github.com/pezra/rspec-mode.git"

  depends_on :emacs => "23.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    ert_run_tests "test/rspec-mode-test.el" unless build.stable?
    byte_compile "rspec-mode.el"
    elisp.install "rspec-mode.el", "rspec-mode.elc"
    pkgshare.install "snippets"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "rspec-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

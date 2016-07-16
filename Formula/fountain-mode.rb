require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class FountainMode < EmacsFormula
  desc "Major mode for the Fountain screenwriting syntax"
  homepage "https://github.com/rnkn/fountain-mode"
  url "https://github.com/rnkn/fountain-mode/archive/v2.1.2.tar.gz"
  sha256 "b75b6fd33457d4445130638377ae4718c83ff6f9d76642f6638a6b4065e84b9f"
  head "https://github.com/rnkn/fountain-mode.git"

  depends_on :emacs => "24.4"
  depends_on "homebrew/emacs/s-emacs"

  def install
    byte_compile "fountain-mode.el"
    elisp.install "fountain-mode.el", "fountain-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/s-emacs"].opt_elisp}")
      (load "fountain-mode")
      (print fountain-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

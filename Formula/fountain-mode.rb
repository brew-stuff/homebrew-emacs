require File.expand_path("../Homebrew/emacs_formula", __dir__)

class FountainMode < EmacsFormula
  desc "Major mode for the Fountain screenwriting syntax"
  homepage "https://github.com/rnkn/fountain-mode"
  url "https://github.com/rnkn/fountain-mode/archive/v2.5.3.tar.gz"
  sha256 "04edf6eb7d229f0e41a47d26facea559c5e91a2f52cadb1137660858bd90ef74"
  head "https://github.com/rnkn/fountain-mode.git"

  bottle :disable

  depends_on EmacsRequirement => "24.4"

  def install
    byte_compile "fountain-mode.el"
    elisp.install "fountain-mode.el", "fountain-mode.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "fountain-mode")
      (print fountain-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

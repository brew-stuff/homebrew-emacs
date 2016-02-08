require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class FountainMode < EmacsFormula
  desc "Major mode for the Fountain screenwriting syntax"
  homepage "https://github.com/rnkn/fountain-mode"
  url "https://github.com/rnkn/fountain-mode/archive/v1.5.1.tar.gz"
  sha256 "2b2862bb5234d3e81c1c45e67e9908803e5bc36a6fc12304b2bde60c99f50b65"
  head "https://github.com/rnkn/fountain-mode.git"

  depends_on :emacs => "24.4"
  depends_on "homebrew/emacs/s"

  def install
    byte_compile "fountain-mode.el"
    elisp.install "fountain-mode.el", "fountain-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/s"].opt_elisp}")
      (load "fountain-mode")
      (print (fountain-export-bold "Homebrew: **the** Brewing"))
    EOS
    assert_equal '"Homebrew: <strong>the</strong> Brewing"',
                 shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

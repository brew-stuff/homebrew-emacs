require File.expand_path("../../emacs", __FILE__)

class FountainMode < Formula
  desc "Major mode for the Fountain screenwriting syntax"
  homepage "https://github.com/rnkn/fountain-mode"
  url "https://github.com/rnkn/fountain-mode/archive/v1.5.0.tar.gz"
  sha256 "433f41332f33265a9fe30215f8e18419c9c11aa640326b0c1d5b09cdb35b1c4f"
  head "https://github.com/rnkn/fountain-mode.git"

  depends_on :emacs => "24.4"
  depends_on "dunn/emacs/s"

  def install
    Emacs.compile "fountain-mode.el"
    (share/"emacs/site-lisp/fountain-mode").install "fountain-mode.el",
                                                    "fountain-mode.elc"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'fountain-mode)
    (add-to-list 'auto-mode-alist '("\\.fountain$" . fountain-mode))
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "fountain-mode")
      (print (fountain-export-bold "Homebrew: **the** Brewing"))
    EOS
    assert_equal "\"Homebrew: <strong>the</strong> Brewing\"",
                 shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

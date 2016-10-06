require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class HaskellMode < EmacsFormula
  desc "Emacs major mode for Haskell"
  homepage "https://github.com/haskell/haskell-mode"
  url "https://github.com/haskell/haskell-mode/archive/v16.1.tar.gz"
  sha256 "109d9a0070825745c20f590c7fd0a1d2bb873d931db5ecc7deea317ab864d43c"
  head "https://github.com/haskell/haskell-mode.git"

  deprecated_option "with-html" => "with-docs"
  option "with-docs", "Build HTML documentation"

  depends_on :emacs => "24.3"
  depends_on "texinfo" if build.with? "docs"

  def install
    system "make"
    system "make", "check"
    elisp.install Dir["*.el"],
                  Dir["build-#{Emacs.version}/*.elc"]

    info.install Dir["*.info"]

    if build.with? "docs"
      system "make", "doc/html"
      doc.install "doc/html"
    end
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "haskell-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

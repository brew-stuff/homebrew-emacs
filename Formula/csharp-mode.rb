require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CsharpMode < EmacsFormula
  desc "Major mode for editing C# code"
  homepage "https://github.com/josteink/csharp-mode"
  url "https://github.com/josteink/csharp-mode/archive/v0.8.12.tar.gz"
  sha256 "ad03db66c09cb7ac1f3843ef96060c41d136b8e7d17b8bccb25b559b3d132b0f"
  head "https://github.com/josteink/csharp-mode"

  depends_on :emacs => "22.1"

  def install
    byte_compile "csharp-mode.el"
    elisp.install "csharp-mode.el", "csharp-mode.elc"
    prefix.install "gpl-2.0.txt"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "csharp-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

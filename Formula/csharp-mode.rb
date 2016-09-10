require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CsharpMode < EmacsFormula
  desc "Major mode for editing C# code"
  homepage "https://github.com/josteink/csharp-mode"
  url "https://github.com/josteink/csharp-mode/archive/v0.9.0.tar.gz"
  sha256 "4232fe0fc4528be543ca1e338ce3e839814f2a5b43e480c16b7b4f1ea1bca3c5"
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

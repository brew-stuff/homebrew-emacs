require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AdaptiveWrap < EmacsFormula
  desc "Emacs minor mode for smart soft-wrapping"
  homepage "https://elpa.gnu.org/packages/adaptive-wrap.html"
  url "https://elpa.gnu.org/packages/adaptive-wrap-0.5.1.el"
  sha256 "940ed8b720efc56d235ffd6ecc78a17094aef956d4eea89a98dc5f96af7c2762"

  depends_on :emacs => "23.1"

  def install
    mv "adaptive-wrap-#{version}.el", "adaptive-wrap.el" if build.stable?

    byte_compile "adaptive-wrap.el"
    elisp.install "adaptive-wrap.el", "adaptive-wrap.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "adaptive-wrap")
      (adaptive-wrap-prefix-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

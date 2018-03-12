require File.expand_path("../Homebrew/emacs_formula", __dir__)

class AdaptiveWrap < EmacsFormula
  desc "Emacs minor mode for smart soft-wrapping"
  homepage "https://elpa.gnu.org/packages/adaptive-wrap.html"
  url "https://elpa.gnu.org/packages/adaptive-wrap-0.5.2.el"
  sha256 "5c094189373adfe0e94483ab957b662dd056761ed3d3da18198b13bb140b8ee1"

  depends_on EmacsRequirement => "23.1"

  def install
    mv "adaptive-wrap-#{version}.el", "adaptive-wrap.el" if build.stable?

    byte_compile "adaptive-wrap.el"
    elisp.install "adaptive-wrap.el", "adaptive-wrap.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "adaptive-wrap")
      (adaptive-wrap-prefix-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

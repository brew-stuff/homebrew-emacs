require File.expand_path("../Homebrew/emacs_formula", __dir__)

class DraculaEmacs < EmacsFormula
  desc "Dark color theme available for a number of editors."
  homepage "https://github.com/dracula/emacs"
  url "https://github.com/dracula/emacs/archive/v1.2.5.tar.gz"
  sha256 "bc78039c90d5d27f6b1ccb7b32fabb3ecbf0d485421bc63ae5d5d6836b9780b4"
  head "https://github.com/dracula/emacs.git"

  bottle :disable

  depends_on EmacsRequirement => "24.1"

  def install
    elisp.install "dracula-theme.el"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'custom-theme-load-path "#{elisp}")
      (load-theme 'dracula t)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

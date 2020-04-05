require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DraculaEmacs < EmacsFormula
  desc "Dark color theme available for a number of editors."
  homepage "https://github.com/dracula/emacs"
  url "https://github.com/dracula/emacs/archive/v1.7.0.tar.gz"
  sha256 "dbbcc968cf8187a8ada9f040137ba03dc0e51b285e96e128d26cea05cf470330"
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

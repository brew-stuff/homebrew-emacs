require File.expand_path("../Homebrew/emacs_formula", __dir__)

class ZenburnEmacs < EmacsFormula
  desc "Low contrast theme for Emacs"
  homepage "https://github.com/bbatsov/zenburn-emacs"
  url "https://github.com/bbatsov/zenburn-emacs/archive/v2.5.tar.gz"
  sha256 "f6811eada38ad53e233f53872a0ab9b5264978c7c6cfffef8e88aeb5de876e0e"
  head "https://github.com/bbatsov/zenburn-emacs.git"

  bottle :unneeded

  depends_on EmacsRequirement => "24.1"

  def install
    elisp.install "zenburn-theme.el"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'custom-theme-load-path "#{elisp}")
      (load-theme 'zenburn t)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

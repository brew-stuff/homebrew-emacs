require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ZenburnEmacs < EmacsFormula
  desc "Low contrast theme for Emacs"
  homepage "https://github.com/bbatsov/zenburn-emacs"
  url "https://github.com/bbatsov/zenburn-emacs/archive/v2.2.tar.gz"
  sha256 "8692349dbb8e65b1f6d914052893717695ddaf8210218188d89fbd23559c51f8"
  head "https://github.com/bbatsov/zenburn-emacs.git"

  bottle :unneeded

  depends_on :emacs => "24.1"

  def install
    elisp.install "zenburn-theme.el"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'custom-theme-load-path "#{elisp}")
      (load-theme 'zenburn t)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

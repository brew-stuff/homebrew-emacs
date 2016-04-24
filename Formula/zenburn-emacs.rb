require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ZenburnEmacs < EmacsFormula
  desc "Low contrast theme for Emacs"
  homepage "https://github.com/bbatsov/zenburn-emacs"
  url "https://github.com/bbatsov/zenburn-emacs/archive/v2.4.tar.gz"
  sha256 "e751cbd62f3a0929e733b6271f621d2556bd6836ef1b0b88dc4769541741d153"
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

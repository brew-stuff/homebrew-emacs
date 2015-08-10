require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ZenburnEmacs < EmacsFormula
  desc "Low contrast theme for Emacs"
  homepage "https://github.com/bbatsov/zenburn-emacs"
  url "https://github.com/bbatsov/zenburn-emacs/archive/v2.2.tar.gz"
  sha256 "8692349dbb8e65b1f6d914052893717695ddaf8210218188d89fbd23559c51f8"
  head "https://github.com/bbatsov/zenburn-emacs.git"

  depends_on :emacs => "24.1"

  def install
    (share/"emacs/site-lisp/zenburn").install "zenburn-theme.el"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (add-to-list 'custom-theme-load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/zenburn")
    (load-theme 'zenburn t)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'custom-theme-load-path "#{share}/emacs/site-lisp/zenburn")
      (load-theme 'zenburn t)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

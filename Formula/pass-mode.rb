require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PassMode < EmacsFormula
  desc "Major mode for password-store"
  homepage "https://github.com/NicolasPetton/pass"
  url "https://github.com/NicolasPetton/pass/archive/1.6.tar.gz"
  sha256 "ec9a99086429f6bb29b8cd5e8d391822de8353b6ce4f150916e7298e50e1f22d"
  head "https://github.com/NicolasPetton/pass.git"

  depends_on :emacs => "24"
  depends_on "pass"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/f-emacs"
  depends_on "homebrew/emacs/s-emacs"

  def install
    byte_compile "pass.el"
    elisp.install "pass.el", "pass.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{Formula["pass"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/f-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/s-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{elisp}")
      (load "pass")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PassMode < EmacsFormula
  desc "Major mode for password-store"
  homepage "https://github.com/NicolasPetton/pass"
  url "https://github.com/NicolasPetton/pass/archive/1.7.tar.gz"
  sha256 "727be1f93adc02590ae6a232864f4f8c44aacfda06af84214e7c60f0cd4e9d7e"
  head "https://github.com/NicolasPetton/pass.git"

  bottle :disable

  depends_on EmacsRequirement => "24"
  depends_on "pass"
  depends_on "dunn/emacs/dash-emacs"
  depends_on "dunn/emacs/f-emacs"
  depends_on "dunn/emacs/s-emacs"
  depends_on "perl" if OS.linux?

  def install
    byte_compile "pass.el"
    elisp.install "pass.el", "pass.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{Formula["pass"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/f-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/s-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{elisp}")
      (load "pass")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

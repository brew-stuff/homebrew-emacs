require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Olivetti < EmacsFormula
  desc "Emacs minor mode for distraction-free writing"
  homepage "https://github.com/rnkn/olivetti"
  url "https://github.com/rnkn/olivetti/archive/v1.5.7.tar.gz"
  sha256 "078b1d23efd04f81bcd196a6cfcc1df0b80e35151953c4cab587c865a4394588"
  head "https://github.com/rnkn/olivetti.git"

  bottle :disable

  depends_on :emacs => "24.4"

  def install
    byte_compile "olivetti.el"
    elisp.install "olivetti.el", "olivetti.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/olivetti")
      (load "olivetti")
      (olivetti-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

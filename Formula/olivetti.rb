require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Olivetti < EmacsFormula
  desc "Emacs minor mode for distraction-free writing"
  homepage "https://github.com/rnkn/olivetti"
  url "https://github.com/rnkn/olivetti/archive/v1.5.9.tar.gz"
  sha256 "f81dc1cc18222979e066104c7e2b4e8db7bfc708d7f4b84d202665ef6a9a49d1"
  head "https://github.com/rnkn/olivetti.git"

  bottle :disable

  depends_on EmacsRequirement => "24.4"

  def install
    byte_compile "olivetti.el"
    elisp.install "olivetti.el", "olivetti.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/olivetti")
      (load "olivetti")
      (olivetti-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

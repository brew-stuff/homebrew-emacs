require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Olivetti < EmacsFormula
  desc "Emacs minor mode for distraction-free writing"
  homepage "https://github.com/rnkn/olivetti"
  url "https://github.com/rnkn/olivetti/archive/v1.5.0.tar.gz"
  sha256 "5e43c10662fb7a17f21a1478ad6caa3942fe29311e994012d9343f5a045413ad"
  head "https://github.com/rnkn/olivetti.git"

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

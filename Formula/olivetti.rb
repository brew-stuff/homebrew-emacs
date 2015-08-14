require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Olivetti < EmacsFormula
  desc "Emacs minor mode for distraction-free writing"
  homepage "https://github.com/rnkn/olivetti"
  url "https://github.com/rnkn/olivetti/archive/v1.2.0.tar.gz"
  sha256 "e94a65f43e22f42be477a1fae028d4192837195b4f2e496a4c62925d47dc4d7d"
  head "https://github.com/rnkn/olivetti.git"

  depends_on :emacs => "24.4"

  def install
    byte_compile "olivetti.el"
    (share/"emacs/site-lisp/olivetti").install "olivetti.el",
                                               "olivetti.elc"
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

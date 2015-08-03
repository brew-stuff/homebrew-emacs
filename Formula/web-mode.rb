require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WebMode < EmacsFormula
  homepage "http://web-mode.org"
  url "https://github.com/fxbois/web-mode/archive/v12.tar.gz"
  sha256 "3a43ce2230d46118576c69297df2409f9fdb62875c369f4f9b3385bcfa259c42"
  head "https://github.com/fxbois/web-mode.git"

  # not tested below 23
  depends_on :emacs => "23.1"

  def install
    system "/bin/bash", "./run.sh"
    byte_compile "web-mode.el"
    (share/"emacs/site-lisp/web-mode").install "web-mode.el", "web-mode.elc"
    doc.install "README.md", "LICENSE"
  end

  def caveats; <<-EOS.undent
    Require web-mode in your init file, then activate it where appropriate, e.g.:

    (require 'web-mode)
    (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
    (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/web-mode")
      (load "web-mode")
      (print web-mode-version)
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

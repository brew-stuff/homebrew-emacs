class WebMode < Formula
  homepage "http://web-mode.org"
  url "https://github.com/fxbois/web-mode/archive/v11.2.tar.gz"
  sha256 "e9e91da7ee0be5f3b0aa018571f42c6963086dd2a446f2554f405a8175543b82"
  head "https://github.com/fxbois/web-mode.git"

  depends_on :emacs => "23"

  def install
    chmod 0755, "run.sh"
    system "./run.sh"
    (share/"emacs/site-lisp").install ["web-mode.el"]
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Require web-mode then activate it where appropriate, e.g.:

      (require 'web-mode)
      (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
      (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
    EOS
  end
end

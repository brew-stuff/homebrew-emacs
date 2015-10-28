require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WebMode < EmacsFormula
  desc "Emacs major mode for editing web templates"
  homepage "http://web-mode.org"
  url "https://github.com/fxbois/web-mode/archive/v12.4.tar.gz"
  sha256 "fd7e83d8ff42e0446d8d18be2f3c2ff9bb70730d0c1f9e81d620d2f02c9d641d"
  head "https://github.com/fxbois/web-mode.git"

  depends_on :emacs => "22.1"

  def install
    system "/bin/bash", "./run.sh"
    byte_compile "web-mode.el"
    (share/"emacs/site-lisp/web-mode").install "web-mode.el", "web-mode.elc"
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

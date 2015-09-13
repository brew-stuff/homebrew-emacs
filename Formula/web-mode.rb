require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WebMode < EmacsFormula
  desc "Emacs major mode for editing web templates"
  homepage "http://web-mode.org"
  url "https://github.com/fxbois/web-mode/archive/v12.2.tar.gz"
  sha256 "ed05fcbd77c102d489421279796e1781c8f5f2eba0c495946d9655a14b3ff3a7"
  head "https://github.com/fxbois/web-mode.git"

  depends_on :emacs => "23.1"

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

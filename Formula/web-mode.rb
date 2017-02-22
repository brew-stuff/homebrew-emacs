require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WebMode < EmacsFormula
  desc "Emacs major mode for editing web templates"
  homepage "http://web-mode.org"
  url "https://github.com/fxbois/web-mode/archive/v14.1.tar.gz"
  sha256 "08bbb0859a01eb1dabe1e53c15d9d0cbc862cb69318c234d0fc34ee8510f41e0"
  head "https://github.com/fxbois/web-mode.git"

  depends_on :emacs => "22.1"

  def install
    system "/bin/bash", "./run.sh"
    byte_compile "web-mode.el"
    elisp.install "web-mode.el", "web-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "web-mode")
      (print web-mode-version)
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

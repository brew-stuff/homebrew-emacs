require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WebMode < EmacsFormula
  desc "Emacs major mode for editing web templates"
  homepage "http://web-mode.org"
  url "https://github.com/fxbois/web-mode/archive/v16.tar.gz"
  sha256 "95ca363af665c3174ac228efc8d239ed0b4ecf2377918093655dc85dd8e979e2"
  head "https://github.com/fxbois/web-mode.git"

  depends_on EmacsRequirement => "23.1"

  def install
    system "/bin/bash", "./run.sh"
    byte_compile "web-mode.el"
    elisp.install "web-mode.el", "web-mode.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "web-mode")
      (print web-mode-version)
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WebMode < EmacsFormula
  desc "Emacs major mode for editing web templates"
  homepage "http://web-mode.org"
  url "https://github.com/fxbois/web-mode/archive/v14.tar.gz"
  sha256 "40ddc857211b575579e2054fcf056fb96e39680bee8f4479c37b1311a101dca0"
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

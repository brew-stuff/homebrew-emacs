require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WebMode < EmacsFormula
  desc "Emacs major mode for editing web templates"
  homepage "http://web-mode.org"
  url "https://github.com/fxbois/web-mode/archive/v13.1.tar.gz"
  sha256 "fc47f82c2a9d723dd8a87657b94f26245b6c2e2e8f230ad4c029fe6d9dd9b6a7"
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

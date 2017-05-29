require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WebMode < EmacsFormula
  desc "Emacs major mode for editing web templates"
  homepage "http://web-mode.org"
  url "https://github.com/fxbois/web-mode/archive/v15.tar.gz"
  sha256 "01724947cde3ac01f998d4e215ee6a2e8358c6a39cf88adb405c9c54e047a18b"
  head "https://github.com/fxbois/web-mode.git"

  depends_on :emacs => "23.1"

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

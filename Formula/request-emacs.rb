require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class RequestEmacs < EmacsFormula
  desc "HTTP request library for Emacs"
  homepage "https://tkf.github.io/emacs-request/"
  url "https://github.com/tkf/emacs-request/archive/v0.3.0.tar.gz"
  sha256 "7f03a011e59df9daa99e54ab423d956f4f12be763836992ced586c8fb2eeec71"
  head "https://github.com/tkf/emacs-request.git"

  depends_on :emacs => "24.4"
  depends_on "dunn/emacs/deferred"

  def install
    byte_compile "request.el", "request-deferred.el"
    elisp.install "request.el", "request.elc",
                  "request-deferred.el", "request-deferred.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "request")
      (print request-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

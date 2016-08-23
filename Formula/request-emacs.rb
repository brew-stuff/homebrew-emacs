require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class RequestEmacs < EmacsFormula
  desc "HTTP request library for Emacs"
  homepage "https://tkf.github.io/emacs-request/"
  url "https://github.com/tkf/emacs-request/archive/v0.2.0.tar.gz"
  sha256 "57f19767852682842a8e41143c48933693f323e9bd5d5472cb5d96d0d34b946a"
  head "https://github.com/tkf/emacs-request.git"

  depends_on :emacs => "24"
  depends_on "homebrew/emacs/deferred"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

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

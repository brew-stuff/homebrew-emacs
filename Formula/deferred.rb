require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Deferred < EmacsFormula
  desc "Simple asynchronous functions for Emacs Lisp "
  homepage "https://github.com/kiwanami/emacs-deferred"
  url "https://github.com/kiwanami/emacs-deferred/archive/v0.4.0.tar.gz"
  sha256 "1f3d615eff3b5199176ff7d84bc1908d48a936125c43c2deac5c073051a3aca5"
  head "https://github.com/kiwanami/emacs-deferred.git"

  depends_on :emacs

  def install
    byte_compile "deferred.el", "concurrent.el"
    elisp.install "deferred.el", "deferred.elc",
                  "concurrent.el", "concurrent.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "deferred")
      (print deferred:version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

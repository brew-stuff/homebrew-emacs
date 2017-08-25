require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Deferred < EmacsFormula
  desc "Simple asynchronous functions for Emacs Lisp "
  homepage "https://github.com/kiwanami/emacs-deferred"
  url "https://github.com/kiwanami/emacs-deferred/archive/v0.5.1.tar.gz"
  sha256 "941b49635cc80ff62c5f568f393b4262c8848b4d27bc88ae8da36549f072e168"
  head "https://github.com/kiwanami/emacs-deferred.git"

  depends_on EmacsRequirement => "24.3"
  depends_on "undercover" => :build

  def install
    ert_run_tests Dir["test/*"]
    system "make", "compile"
    elisp.install "deferred.el", "deferred.elc",
                  "concurrent.el", "concurrent.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "deferred")
      (print deferred:version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

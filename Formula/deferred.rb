require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Deferred < EmacsFormula
  desc "Simple asynchronous functions for Emacs Lisp "
  homepage "https://github.com/kiwanami/emacs-deferred"
  head "https://github.com/kiwanami/emacs-deferred.git"

  stable do
    url "https://github.com/kiwanami/emacs-deferred/archive/v0.5.0.tar.gz"
    sha256 "6e587cc5e4505fa42ab1f0e9d8fc8d0c68e5feed257eaec1272cac6b94ac24c8"

    patch do
      url "https://github.com/kiwanami/emacs-deferred/commit/7bfe8428c92377140a0fff6d1bb310fa027c8672.diff"
      sha256 "1fbbd48c5b4e268a5172c3b07e3f6cb6e2eb63df572c6d3f04cf5de122d42c76"
    end
  end

  depends_on EmacsRequirement => "24.3"

  def install
    system "make", "compile"
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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Pcache < EmacsFormula
  desc "Persistent caching for Emacs"
  homepage "https://github.com/sigma/pcache"
  url "https://github.com/sigma/pcache/archive/v0.4.1.tar.gz"
  sha256 "1b70e6ec242e9f5c984f00acdcc06bb1d01ac8985fc56f5f7b354ac2d84bd02d"
  head "https://github.com/sigma/pcache.git"

  depends_on :emacs

  def install
    ert_run_tests "test/pcache-test.el"
    byte_compile "pcache.el"
    elisp.install "pcache.el", "pcache.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "pcache")
      (print (let ((repo (pcache-repository "plop")))
        (pcache-put repo 'home "brew")
        (pcache-get repo 'home)))
    EOS
    assert_equal "\"brew\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Pcache < EmacsFormula
  desc "Persistent caching for Emacs"
  homepage "https://github.com/sigma/pcache"
  url "https://github.com/sigma/pcache/archive/v0.4.2.tar.gz"
  sha256 "c0411bfa4a6625b5c17e3c47f1d3a897298c22bbc9234c06333a5efab0ada4fb"
  head "https://github.com/sigma/pcache.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4cc455cc9a1ec8e0f950af59e45983ec1a56e3c1b870e488a15ee07647f0aa4" => :sierra
    sha256 "6b66caa78eef4855d7b99f87b436e761be0f7ad13f2e845edb97c2012884a7a4" => :el_capitan
    sha256 "6b66caa78eef4855d7b99f87b436e761be0f7ad13f2e845edb97c2012884a7a4" => :yosemite
  end

  depends_on EmacsRequirement => "24.1"

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

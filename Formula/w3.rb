# coding: utf-8
require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class W3 < EmacsFormula
  desc "Emacs web browser"
  homepage "https://elpa.gnu.org/packages/w3.html"
  url "https://elpa.gnu.org/packages/w3-4.0.49.tar"
  sha256 "6be119e18fb6d4130be22f3aafc7d75b91b0b6ee3b28ed3b42a2f3371619c306"
  head "http://git.savannah.gnu.org/r/emacs/elpa.git", branch: "externals/w3"

  bottle do
    cellar :any_skip_relocation
    sha256 "2593f02cf26ce94ea59723a8ac0f115ea4f9abfffcbf3f53cafbce32cc9030f4" => :sierra
    sha256 "2593f02cf26ce94ea59723a8ac0f115ea4f9abfffcbf3f53cafbce32cc9030f4" => :el_capitan
    sha256 "2593f02cf26ce94ea59723a8ac0f115ea4f9abfffcbf3f53cafbce32cc9030f4" => :yosemite
  end

  depends_on EmacsRequirement

  def install
    ert_run_tests "tests/url-test.el"

    # there's a Makefile.in but no configure or configure.ac
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"], "etc"
    prefix.install "contrib"
    doc.install "texi"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "w3")
      (w3-fetch "http://brew.sh")
      (print (minibuffer-prompt-width))
    EOS
    assert_match "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

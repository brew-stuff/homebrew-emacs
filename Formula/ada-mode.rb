require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AdaMode < EmacsFormula
  desc "Emacs major mode for editing Ada sources"
  homepage "http://www.nongnu.org/ada-mode/"
  url "https://elpa.gnu.org/packages/ada-mode-5.3.1.tar"
  sha256 "a965690bc8399fb6d25c7a7f7b9a8dfb995751672b00059007d80a3ff851366b"

  bottle :disable

  option "without-reference", "Build without the reference manual"

  depends_on EmacsRequirement => "24.2"
  depends_on "dunn/emacs/wisi"

  resource "reference" do
    url "http://stephe-leake.org/ada/arm_info-2012.3.tar.gz"
    sha256 "e0961268ecf6bb3c852d88d9f6ff4a8518e98c607cd264f70bb9c38389458461"
  end

  def install
    # there's `make byte-compile` but it uses package.el
    byte_compile (Dir["*.el"] - %w[ada-mode-pkg.el])
    elisp.install (Dir["*.el"] - %w[ada-mode-pkg.el]), Dir["*.elc"]

    info.install Dir["*.info"]
    if build.with? "reference"
      resource("reference").stage { info.install Dir["*"] }
    end
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["wisi"].opt_elisp}")
      (load "ada-mode")
      (print (ada-mode-version))
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

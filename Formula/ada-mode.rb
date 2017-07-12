require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AdaMode < EmacsFormula
  desc "Emacs major mode for editing Ada sources"
  homepage "http://www.nongnu.org/ada-mode/"
  url "https://elpa.gnu.org/packages/ada-mode-5.2.2.tar"
  sha256 "6dbf0ef0b16a9e4fc6020b2fcf4f5a1eb866f73bcb2d0cb5e76ae9b789cc1430"

  bottle :disable

  option "without-reference", "Build without the reference manual"

  depends_on :emacs => "24.2"
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

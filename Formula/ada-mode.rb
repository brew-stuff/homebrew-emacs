require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AdaMode < EmacsFormula
  desc "Emacs major mode for editing Ada sources"
  homepage "http://www.nongnu.org/ada-mode/"
  url "https://elpa.gnu.org/packages/ada-mode-5.2.1.tar"
  sha256 "64f03d662500335b27e60f69635d181843e3cfd16b07949cbb9e6f69ea462c25"

  bottle do
    cellar :any_skip_relocation
    sha256 "5dec9c6f52c55475ef689fa17a6545b3f82901f029269709ff22ee64cd373879" => :sierra
    sha256 "5dec9c6f52c55475ef689fa17a6545b3f82901f029269709ff22ee64cd373879" => :el_capitan
    sha256 "5dec9c6f52c55475ef689fa17a6545b3f82901f029269709ff22ee64cd373879" => :yosemite
  end

  option "without-reference", "Build without the reference manual"

  depends_on :emacs => "24.2"
  depends_on "homebrew/emacs/wisi-emacs"

  resource "reference" do
    url "http://stephe-leake.org/ada/arm_info-2012.2.tar.gz"
    sha256 "e861098b37faf38289b0ada9543bb2f846285080512d86e052a4154d0a800e61"
  end

  def install
    # there's `make byte-compile` but it uses package.el
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]

    info.install Dir["*.info"]
    if build.with? "reference"
      resource("reference").stage { info.install Dir["*"] }
    end
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["wisi-emacs"].opt_elisp}")
      (load "ada-mode")
      (print (ada-mode-version))
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

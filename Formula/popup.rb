require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Popup < EmacsFormula
  desc "Visual popup interface library for Emacs"
  homepage "https://github.com/auto-complete/popup-el"
  url "https://github.com/auto-complete/popup-el/archive/v0.5.3.tar.gz"
  sha256 "8035782f642f346ba768fa408e4120a9368b0c86f43e3ecd62b527e391742ffb"
  head "https://github.com/auto-complete/popup-el.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "185a95d7bae875a306141dabb88bbc3f8729c6a3cf0073b816d6b42abfcd6690" => :sierra
    sha256 "185a95d7bae875a306141dabb88bbc3f8729c6a3cf0073b816d6b42abfcd6690" => :el_capitan
    sha256 "185a95d7bae875a306141dabb88bbc3f8729c6a3cf0073b816d6b42abfcd6690" => :yosemite
  end

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    ert_run_tests "tests/popup-test.el"
    byte_compile "popup.el"
    elisp.install "popup.el", "popup.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "popup")
      (print popup-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

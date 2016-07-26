require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Popup < EmacsFormula
  desc "Visual popup interface library for Emacs"
  homepage "https://github.com/auto-complete/popup-el"
  url "https://github.com/auto-complete/popup-el/archive/v0.5.3.tar.gz"
  sha256 "8035782f642f346ba768fa408e4120a9368b0c86f43e3ecd62b527e391742ffb"
  head "https://github.com/auto-complete/popup-el.git"

  # only tested on 24
  depends_on :emacs => "24.1"
  depends_on "cask"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    system "make", "travis-ci", "CASK=#{Formula["cask"].bin}/cask"

    byte_compile "popup.el"
    (share/"emacs/site-lisp/popup").install "popup.el", "popup.elc"
    doc.install "README.md"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/popup")
      (load "popup")
      (print popup-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

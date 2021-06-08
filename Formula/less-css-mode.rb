require File.expand_path("../Homebrew/emacs_formula", __dir__)

class LessCssMode < EmacsFormula
  desc "Major mode for editing .less files in Emacs"
  homepage "https://github.com/purcell/less-css-mode"
  url "https://github.com/purcell/less-css-mode/archive/0.21.tar.gz"
  sha256 "c0fcf73526b66e2eb1f0bfa6c7ca0f1aab9e3f7ba2b3c08252fab7ccf2da2b71"
  head "https://github.com/purcell/less-css-mode.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1bc74cc2f12dcf6a5d11f7d38a62a387c7a72b6f2b04cbad1e2784cf182d571" => :sierra
    sha256 "d1bc74cc2f12dcf6a5d11f7d38a62a387c7a72b6f2b04cbad1e2784cf182d571" => :el_capitan
    sha256 "d1bc74cc2f12dcf6a5d11f7d38a62a387c7a72b6f2b04cbad1e2784cf182d571" => :yosemite
  end

  depends_on EmacsRequirement => "22.2"

  def install
    byte_compile "less-css-mode.el"
    elisp.install "less-css-mode.el", "less-css-mode.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "less-css-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PosTip < EmacsFormula
  desc "Tooltips for Emacs"
  homepage "https://github.com/pitkali/pos-tip"
  url "https://github.com/pitkali/pos-tip/archive/0.4.6.tar.gz"
  sha256 "5934257ec49c587681cc37f9d3f774053124f147d623a500a667ca6d8477588a"
  head "https://github.com/pitkali/pos-tip.git"

  depends_on EmacsRequirement => "22.1"

  def install
    byte_compile "pos-tip.el"
    elisp.install "pos-tip.el", "pos-tip.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "pos-tip")
      (print pos-tip-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

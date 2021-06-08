require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Epl < EmacsFormula
  desc "package.el API"
  homepage "https://github.com/cask/epl"
  url "https://github.com/cask/epl/archive/0.8.tar.gz"
  sha256 "2cabc9324cf7a88abf1bc00c3fe2f79105e3170a005ab28453fb1537d4b02194"
  head "https://github.com/cask/epl.git"

  depends_on EmacsRequirement => "24.1"
  depends_on "cask"

  def install
    system "make", "compile"
    system "make", "test"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "elp")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

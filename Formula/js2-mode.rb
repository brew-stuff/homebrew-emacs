require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Js2Mode < EmacsFormula
  desc "Improved major mode for editing JavaScript in Emacs"
  homepage "https://github.com/mooz/js2-mode"
  url "https://github.com/mooz/js2-mode/archive/20180301.tar.gz"
  sha256 "83972a5f3736d80250816dbd002d2785283f45f199b9b8ee70ab66acf8834f8d"
  head "https://github.com/mooz/js2-mode.git"

  bottle :disable

  depends_on EmacsRequirement => "24.1"

  def install
    system "make", "all"
    system "make", "test"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "js2-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../Homebrew/emacs_formula", __dir__)

class MultipleCursors < EmacsFormula
  desc "Multiple cursors for Emacs"
  homepage "https://github.com/magnars/multiple-cursors.el"
  url "https://github.com/magnars/multiple-cursors.el/archive/1.4.0.tar.gz"
  sha256 "33a1c193cf8bcb0c80f71a154cbbc1956ee80a79ec63ebcaf3ea6fb6298c3042"
  head "https://github.com/magnars/multiple-cursors.el.git"

  depends_on EmacsRequirement

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "multiple-cursors")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

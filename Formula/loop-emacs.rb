require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class LoopEmacs < EmacsFormula
  desc "Friendly imperative loop structures for Emacs lisp"
  homepage "https://github.com/Wilfred/loop.el"
  url "https://github.com/Wilfred/loop.el/archive/1.3.tar.gz"
  sha256 "4945498a4f7ff4cd85315a1d3480e41c03452e05df8340ccf84b49ff078479fc"
  head "https://github.com/Wilfred/loop.el.git"

  depends_on EmacsRequirement => "24.3"

  def install
    byte_compile "loop.el"
    elisp.install "loop.el", "loop.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "loop")
      (print (let ((x 0) (sum 0))
        (loop-while (< x 10)
          (setq sum (+ sum x))
          (setq x (1+ x)))
          sum))
    EOS
    assert_equal "45", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

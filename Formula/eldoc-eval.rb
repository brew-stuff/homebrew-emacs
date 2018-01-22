require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class EldocEval < EmacsFormula
  desc "Package for eldoc support when minibuffer is in use"
  homepage "https://github.com/thierryvolpiatto/eldoc-eval"
  url "https://github.com/thierryvolpiatto/eldoc-eval/archive/v1.1.tar.gz"
  sha256 "9250d2a3506eff7bc7496e8d0033e5afde4effe8f58e83b27cfc4071e751b33c"
  head "https://github.com/thierryvolpiatto/eldoc-eval.git"

  depends_on EmacsRequirement => "24.4"

  def install
    byte_compile "eldoc-eval.el"
    elisp.install "eldoc-eval.el", "eldoc-eval.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "eldoc-eval")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

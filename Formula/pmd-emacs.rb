require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PmdEmacs < EmacsFormula
  desc "Major mode for plugging PMD into Emacs"
  homepage "https://github.com/pmd/pmd-emacs"
  url "https://github.com/pmd/pmd-emacs/archive/0.8.tar.gz"
  sha256 "d4677bf1039f2a25b0a029c593bfc1f442c8fb0807b17092ce422cd25f390f42"
  head "https://github.com/pmd/pmd-emacs.git"

  depends_on EmacsRequirement => "22.1"
  depends_on "pmd"

  def install
    cd "src/elisp" do
      byte_compile "pmd.el"
      elisp.install "pmd.el", "pmd.elc"
    end
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "pmd")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../Homebrew/emacs_formula", __dir__)

class AssessEmacs < EmacsFormula
  desc "Test support functions for Emacs"
  homepage "https://github.com/phillord/assess"
  url "https://github.com/phillord/assess/archive/v0.4.tar.gz"
  sha256 "534165cafe5f4aa248e60122bb4237fee2eb471274504ecb6bf14b4a15fc01a7"
  head "https://github.com/phillord/assess.git"

  bottle :disable

  depends_on EmacsRequirement => "24.1"
  depends_on "cask" => :build

  depends_on "dunn/emacs/seq"
  depends_on "dunn/emacs/m-buffer"

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/m-buffer"].opt_elisp}")
      (load "assess")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

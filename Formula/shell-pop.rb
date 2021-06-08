require File.expand_path("../Homebrew/emacs_formula", __dir__)

class ShellPop < EmacsFormula
  desc "Easier shell access in Emacs"
  homepage "https://github.com/kyagi/shell-pop-el"
  url "https://github.com/kyagi/shell-pop-el/archive/0.63.tar.gz"
  sha256 "71a86e70540e84ec2d2bff2eb587b358cb0cd2b094763a29bd8c45b7ea3a8420"
  head "https://github.com/kyagi/shell-pop-el"

  depends_on EmacsRequirement => "24.1"

  def install
    byte_compile "shell-pop.el"
    elisp.install "shell-pop.el", "shell-pop.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "shell-pop")
      (shell-pop 1)
      (print (buffer-name))
    EOS
    assert_equal "\"*shell-1*\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

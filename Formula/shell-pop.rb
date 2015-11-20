require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ShellPop < EmacsFormula
  desc "Easier shell access in Emacs"
  homepage "https://github.com/kyagi/shell-pop-el"
  url "https://github.com/kyagi/shell-pop-el/archive/0.62.tar.gz"
  sha256 "49543584dce97fea5fc2ca45d55e4e162250cecb722d9b2e1ef0e31d80c3b3c2"
  head "https://github.com/kyagi/shell-pop-el"

  depends_on :emacs => "24.1"

  def install
    byte_compile "shell-pop.el"
    elisp.install "shell-pop.el", "shell-pop.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "shell-pop")
      (shell-pop 1)
      (print (buffer-name))
    EOS
    assert_equal "\"*shell-1*\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

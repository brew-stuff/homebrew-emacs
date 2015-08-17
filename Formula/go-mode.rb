require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class GoMode < EmacsFormula
  desc "Emacs major mode for editing Go"
  homepage "https://github.com/dominikh/go-mode.el"
  url "https://github.com/dominikh/go-mode.el/archive/v1.3.1.tar.gz"
  sha256 "5a6dc7e6c2129ab7eaa205286ada46b0eba2206829461c0a667f256b2fb35570"
  head "https://github.com/dominikh/go-mode.el"

  depends_on :emacs

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/go-mode").install Dir["*.el"], Dir["*.elc"]
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'go-mode-autoloads)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/go-mode")
      (load "go-mode-autoloads")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

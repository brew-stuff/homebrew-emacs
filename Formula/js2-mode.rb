class Js2Mode < Formula
  desc "Improved major mode for editing JavaScript in Emacs"
  homepage "https://github.com/mooz/js2-mode"
  url "https://github.com/mooz/js2-mode/archive/20150713.tar.gz"
  sha256 "ae59eb9139eed5f67f2b4d282fd318f1c8d363727b00878f9f8517a7ff0ce668"
  head "https://github.com/mooz/js2-mode.git"

  depends_on :emacs => "24.1"

  def install
    system "make"
    system "make", "test"
    (share/"emacs/site-lisp/js2-mode").install Dir["*.el"],
                                               Dir["*.elc"]
    doc.install Dir["*.md"]
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'js2-mode)
    (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
    (add-to-list 'interpreter-mode-alist '("node" . js2-mode))
    (add-to-list 'interpreter-mode-alist '("iojs" . js2-mode))
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/")
      (load "js2-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

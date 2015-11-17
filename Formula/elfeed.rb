require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Elfeed < EmacsFormula
  desc "extensible web feed reader for Emacs"
  homepage "https://github.com/skeeto/elfeed"
  url "https://github.com/skeeto/elfeed/archive/1.2.0.tar.gz"
  sha256 "7532609c0fd8491ed6fd49fdb6c3474ff4d970a833b94c3da4cd9f9f34387e53"
  head "https://github.com/skeeto/elfeed.git"

  depends_on :emacs

  def install
    system "make", "compile"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'elfeed)
    (global-set-key (kbd "C-x w") 'elfeed)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "elfeed")
      (elfeed)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

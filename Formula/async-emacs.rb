require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AsyncEmacs < EmacsFormula
  desc "Emacs library for asynchronous processing"
  homepage "https://github.com/jwiegley/emacs-async"
  url "https://github.com/jwiegley/emacs-async/archive/v1.4.tar.gz"
  sha256 "295d6d5dd759709ef714a7d05c54aa2934f2ffb4bb2e90e4434415f75f05473b"
  head "https://github.com/jwiegley/emacs-async.git"

  depends_on :emacs

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/async").install Dir["*.el"],
                                            Dir["*.elc"]
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'async)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/async")
      (load "async")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

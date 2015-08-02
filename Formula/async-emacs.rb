require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AsyncEmacs < EmacsFormula
  desc "Emacs library for asynchronous processing"
  homepage "https://github.com/jwiegley/emacs-async"
  url "https://github.com/jwiegley/emacs-async/archive/v1.3.tar.gz"
  sha256 "1d60850f591b42b25eff655c6b58c199c7efe7553e0f0908a2867b73b3d4eafb"
  head "https://github.com/jwiegley/emacs-async.git"

  depends_on :emacs

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/async").install Dir["*.el"],
                                            Dir["*.elc"]
    doc.install "README.md"
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

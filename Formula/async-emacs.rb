require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AsyncEmacs < EmacsFormula
  desc "Emacs library for asynchronous processing"
  homepage "https://github.com/jwiegley/emacs-async"
  url "https://github.com/jwiegley/emacs-async/archive/v1.6.tar.gz"
  sha256 "9962c7bced1fe663ba741a2e85ac9e71a4206ad5c7e47486d75e98e0b7faa7eb"
  head "https://github.com/jwiegley/emacs-async.git"

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "async")
      (let ((fut (async-start
             (lambda () (sleep-for 2) "mkdir brew"))))
        (shell-command (async-get fut)))
    EOS
    system "emacs", "-Q", "--batch", "-l", "#{testpath}/test.el"
    sleep 3
    (testpath/"brew").directory?
  end
end

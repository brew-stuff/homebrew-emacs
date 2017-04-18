require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AsyncEmacs < EmacsFormula
  desc "Emacs library for asynchronous processing"
  homepage "https://github.com/jwiegley/emacs-async"
  url "https://github.com/jwiegley/emacs-async/archive/v1.9.1.tar.gz"
  sha256 "45f78bf7356ee80c6e1ac9971f3768d57acca602dabbbc20c1a61b90ec4a0b2a"
  head "https://github.com/jwiegley/emacs-async.git"

  depends_on :emacs
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AsyncEmacs < EmacsFormula
  desc "Emacs library for asynchronous processing"
  homepage "https://github.com/jwiegley/emacs-async"
  url "https://github.com/jwiegley/emacs-async/archive/v1.9.3.tar.gz"
  sha256 "eadd291e75dd05aa1a0c7199ecc936b8c18b7981220612cb018f4c2ad0ba0c9d"
  head "https://github.com/jwiegley/emacs-async.git"

  depends_on EmacsRequirement
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    system "make", "all"
    elisp.mkpath
    system "make", "install", "DESTDIR=#{elisp}"
  end

  test do
    (testpath/"test.el").write <<~EOS
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

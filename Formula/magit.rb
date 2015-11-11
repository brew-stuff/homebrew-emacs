require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Magit < EmacsFormula
  desc "Emacs interface for Git"
  homepage "https://github.com/magit/magit"
  url "https://github.com/magit/magit/releases/download/2.3.1/magit-2.3.1.tar.gz"
  sha256 "ee9574dc20cd078d62d669dc19caf8ffc29480a01184d6bc5e90cfa6c800ddf2"
  head "https://github.com/magit/magit.git", :shallow => false

  depends_on :emacs => "24.4"
  depends_on "homebrew/emacs/async-emacs"
  depends_on "homebrew/emacs/dash-emacs"

  def install
    (buildpath/"config.mk").write <<-EOS
      LOAD_PATH = -L #{buildpath}/lisp \
                  -L #{Formula["homebrew/emacs/dash-emacs"].opt_elisp} \
                  -L #{Formula["homebrew/emacs/async-emacs"].opt_elisp}
    EOS
    args = %W[
      PREFIX=#{prefix}
      docdir=#{doc}
      VERSION=#{version}
    ]
    system "make", "install", *args
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/async-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (load "magit")
      (magit-run-git "init")
    EOS
    system "emacs", "--batch", "-Q", "-l", "#{testpath}/test.el"
    File.exist? ".git"
  end
end

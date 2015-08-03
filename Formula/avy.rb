require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Avy < EmacsFormula
  desc "Emacs library for navigating text via trees"
  homepage "https://github.com/abo-abo/avy"
  url "https://github.com/abo-abo/avy/archive/0.3.0.tar.gz"
  sha256 "db1323acf64a26010d476f793f108a1ad8fb3aba8e6b1759bf307d22d14c070a"
  head "https://github.com/abo-abo/avy.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    system "make", "compile"
    (share/"emacs/site-lisp/avy").install Dir["*.el"], Dir["*.elc"]
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'avy)
    (avy-setup-default)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/avy")
      (load "avy")
      (avy-setup-default)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

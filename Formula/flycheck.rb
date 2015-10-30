require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Flycheck < EmacsFormula
  desc "On-the-fly syntax checking extension"
  homepage "http://www.flycheck.org/"
  url "https://github.com/flycheck/flycheck/archive/0.24.tar.gz"
  sha256 "b2b7a98c70029f9c4382c5e22f215750eb6a5b6a82d6987bd40f34fb152d57e3"
  head "https://github.com/flycheck/flycheck.git"

  depends_on :emacs => "24.3"

  option "with-package", "Install flycheck-package"

  depends_on "cask"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/let-alist"
  depends_on "homebrew/emacs/pkg-info"

  resource "package" do
    url "https://github.com/purcell/flycheck-package/archive/0.8.tar.gz"
    sha256 "86bcccb66b68ea31707429c0da59fe616a9ecc93a8b9e782055758a4888ca030"
  end

  def install
    if build.with? "package"
      resource("package").stage do
        byte_compile "flycheck-package.el"
        (share/"emacs/site-lisp/flycheck").install "flycheck-package.el"
      end
    end

    system "make", "compile", "CASK=#{Formula["cask"].bin}/cask"
    (share/"emacs/site-lisp/flycheck").install Dir["*.el"],
                                               Dir["*.elc"]
    doc.install "README.md", Dir["doc/*"]
  end

  def caveats
    s = <<-EOS.undent
      Add the following to your init file:

      (require 'flycheck)
      (add-hook 'after-init-hook #'global-flycheck-mode)
    EOS
    if build.with? "package"
      s += <<-EOS.undent

      (eval-after-load 'flycheck
        '(flycheck-package-setup))
    EOS
    end
    s
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/flycheck")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/pkg-info"].opt_share}/emacs/site-lisp/pkg-info")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_share}/emacs/site-lisp/dash")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/epl"].opt_share}/emacs/site-lisp/epl")
      (load "flycheck")
      (load "pkg-info")
      (print (flycheck-version))
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

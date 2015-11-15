require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Flycheck < EmacsFormula
  desc "On-the-fly syntax checking extension"
  homepage "http://www.flycheck.org/"
  url "https://github.com/flycheck/flycheck/archive/0.25.tar.gz"
  sha256 "dc85d1e67a83020aafc63df980aa6bbb07595f6ef32d8888089066b8f62ad34a"
  head "https://github.com/flycheck/flycheck.git"

  option "with-package", "Install flycheck-package"

  depends_on :emacs => "24.3"
  depends_on "cask"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/let-alist"
  depends_on "homebrew/emacs/pkg-info"
  depends_on "homebrew/emacs/seq"

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
    elisp.install Dir["*.el"], Dir["*.elc"]
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/pkg-info"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/epl"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/seq"].opt_elisp}")
      (load "flycheck")
      (load "pkg-info")
      (print (flycheck-version))
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

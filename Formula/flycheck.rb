require File.expand_path("../../Homebrew/emacs-formula", __FILE__)

class Flycheck < EmacsFormula
  desc "On-the-fly syntax checking extension"
  homepage "http://www.flycheck.org/"

  stable do
    url "https://github.com/flycheck/flycheck/archive/0.23.tar.gz"
    sha256 "edda4967780f3566842c87b7a5d7f2630be593b9029a7909e5c02f68c82ee9e3"
    depends_on :emacs => "24.1"
  end

  head do
    url "https://github.com/flycheck/flycheck.git"
    depends_on :emacs => "24.3"
  end

  depends_on "cask"
  depends_on "dunn/emacs/dash"
  depends_on "dunn/emacs/let-alist"
  depends_on "dunn/emacs/pkg-info"

  def install
    system "make", "compile", "CASK=#{Formula["cask"].bin}/cask"

    (share/"emacs/site-lisp/flycheck").install Dir["*.el"],
                                               Dir["*.elc"]
    doc.install "README.md", Dir["doc/*"]
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'flycheck)
    (add-hook 'after-init-hook #'global-flycheck-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "flycheck")
      (load "pkg-info")
      (print (flycheck-version))
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

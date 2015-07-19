class Flycheck < Formula
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

  def install
    system "make", "compile", "EMACS=#{which "emacs"}",
                              "CASK=#{Formula["cask"].bin}/cask"

    (share/"emacs/site-lisp/flycheck").install Dir["*.el"],
                                               Dir["*.elc"]

    doc.install "README.md", Dir["doc/*"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/flycheck")
      (require 'flycheck)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

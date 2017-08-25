require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Enwc < EmacsFormula
  desc "The Emacs Network Client"
  homepage "https://elpa.gnu.org/packages/enwc.html"
  url "https://elpa.gnu.org/packages/enwc-2.0.tar"
  sha256 "b60a1997142d2070167d847bae4f4cda6f39788916004c6d0ab65465c02a839f"

  depends_on EmacsRequirement => "24.3"

  def install
    elisp.mkpath
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/enwc")
      (load "enwc")
      (enwc)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

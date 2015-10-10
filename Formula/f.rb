require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class F < EmacsFormula
  desc "Emacs filesystem API"
  homepage "https://github.com/rejeep/f.el"
  url "https://github.com/rejeep/f.el/archive/v0.18.0.tar.gz"
  sha256 "38fae0e2288bb55bfb9d692ec3a4f295661e2456e8909927bc3ba034b1f282ec"
  head "https://github.com/rejeep/f.el.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/s"

  def install
    # make test/compile requires emacs-parallel
    byte_compile "f.el"
    (share/"emacs/site-lisp/f").install "f.el", "f.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/f")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].share}/emacs/site-lisp/dash")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/s"].share}/emacs/site-lisp/s")
      (load "f")
      (print (f-this-file))
    EOS
    assert_equal "\"#{testpath}/test.el\"",
                 shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

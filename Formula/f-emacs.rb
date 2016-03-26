require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class FEmacs < EmacsFormula
  desc "Emacs filesystem API"
  homepage "https://github.com/rejeep/f.el"
  url "https://github.com/rejeep/f.el/archive/v0.18.1.tar.gz"
  sha256 "ebc75d44aa9090c47bc6f110bfaae5f583e09fa3ce43846644dccefb6194171e"
  head "https://github.com/rejeep/f.el.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/s-emacs"

  def install
    # make test/compile requires emacs-parallel
    byte_compile "f.el"
    elisp.install "f.el", "f.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/s-emacs"].opt_elisp}")
      (load "f")
      (print (f-this-file))
    EOS
    assert_equal "\"#{testpath}/test.el\"",
                 shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

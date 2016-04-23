require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class FEmacs < EmacsFormula
  desc "Emacs filesystem API"
  homepage "https://github.com/rejeep/f.el"
  url "https://github.com/rejeep/f.el/archive/v0.18.2.tar.gz"
  sha256 "e5791b653128f6508244a64096526439fcff6b40011b56c07fba552f20d446a4"
  head "https://github.com/rejeep/f.el.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/s-emacs"

  def install
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

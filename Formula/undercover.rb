require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Undercover < EmacsFormula
  desc "Test coverage library for Emacs"
  homepage "https://github.com/sviridov/undercover.el"
  url "https://github.com/sviridov/undercover.el/archive/v0.5.0.tar.gz"
  sha256 "a8adcd65bfb8167d965ebefe28ee344c644b119df673aafe893dd98ef4568cc9"
  head "https://github.com/sviridov/undercover.el.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/shut-up"

  def install
    byte_compile "undercover.el"
    elisp.install "undercover.el", "undercover.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/shut-up"].opt_elisp}")
      (load "undercover")
      (print undercover-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Undercover < EmacsFormula
  desc "Test coverage library for Emacs"
  homepage "https://github.com/sviridov/undercover.el"
  url "https://github.com/sviridov/undercover.el/archive/v0.6.0.tar.gz"
  sha256 "0ad4923504787f0e7bd2eaace841b68d075c532d08be2cd0d0582fdb41748838"
  head "https://github.com/sviridov/undercover.el.git"

  depends_on :emacs => "24.1"
  depends_on "dunn/emacs/dash-emacs"
  depends_on "dunn/emacs/shut-up"

  def install
    byte_compile "undercover.el"
    elisp.install "undercover.el", "undercover.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/shut-up"].opt_elisp}")
      (load "undercover")
      (print undercover-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Undercover < EmacsFormula
  desc "Test coverage library for Emacs"
  homepage "https://github.com/sviridov/undercover.el"
  url "https://github.com/sviridov/undercover.el/archive/0.6.1.tar.gz"
  sha256 "c7b69b33b41df47dc67b499c6dbec9a8d775f2c8eeab9de22ee1fe7f1155fc6f"
  head "https://github.com/sviridov/undercover.el.git"

  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/dash-emacs"
  depends_on "dunn/emacs/shut-up"

  def install
    byte_compile "undercover.el"
    elisp.install "undercover.el", "undercover.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/shut-up"].opt_elisp}")
      (load "undercover")
      (print undercover-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../Homebrew/emacs_formula", __dir__)

class RubocopEmacs < EmacsFormula
  desc "Emacs interface for RuboCop"
  homepage "https://github.com/bbatsov/rubocop-emacs"
  url "https://github.com/bbatsov/rubocop-emacs/archive/v0.5.0.tar.gz"
  sha256 "4fe70cfa4ee1134613e5fb20c55958cbc4d27d6df758a657746d04dd296876f8"
  head "https://github.com/bbatsov/rubocop-emacs.git"

  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/dash-emacs"

  def install
    byte_compile "rubocop.el"
    elisp.install "rubocop.el", "rubocop.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{Formula["dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{elisp}")
      (load "rubocop")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

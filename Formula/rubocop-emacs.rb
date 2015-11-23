require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class RubocopEmacs < EmacsFormula
  desc "Emacs interface for RuboCop"
  homepage "https://github.com/bbatsov/rubocop-emacs"
  url "https://github.com/bbatsov/rubocop-emacs/archive/v0.4.0.tar.gz"
  sha256 "b3dadd72c7f06607576949cbf388c2c62acc42313b02a088a308e6f36807e43a"
  head "https://github.com/bbatsov/rubocop-emacs.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/dash-emacs"

  def install
    byte_compile "rubocop.el"
    elisp.install "rubocop.el", "rubocop.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{Formula["dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{elisp}")
      (load "rubocop")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class InfRuby < EmacsFormula
  desc "Emacs REPL buffer connected to a Ruby subprocess"
  homepage "https://github.com/nonsequitur/inf-ruby"
  url "https://github.com/nonsequitur/inf-ruby/archive/2.4.0.tar.gz"
  sha256 "39e847194d813b00f242e6d04a9bc1169cab5181212c5f69b8f1afa59df2bdc0"
  head "https://github.com/nonsequitur/inf-ruby.git"

  depends_on :emacs

  def install
    byte_compile "inf-ruby.el"
    (share/"emacs/site-lisp/inf-ruby").install "inf-ruby.el",
                                               "inf-ruby.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'inf-ruby)
    (autoload 'inf-ruby-minor-mode "inf-ruby" "Run an inferior Ruby process" t)
    (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/inf-ruby")
      (load "inf-ruby")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

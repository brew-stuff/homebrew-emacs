require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class InfRuby < EmacsFormula
  desc "Emacs REPL buffer connected to a Ruby subprocess"
  homepage "https://github.com/nonsequitur/inf-ruby"
  url "https://github.com/nonsequitur/inf-ruby/archive/2.5.0.tar.gz"
  sha256 "a80c34c7858e1c2573e9250b36952f518b000c47187fe7965362f0c7becef2b6"
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

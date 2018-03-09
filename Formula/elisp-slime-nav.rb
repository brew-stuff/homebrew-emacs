require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ElispSlimeNav < EmacsFormula
  desc "Slime-style navigation of Emacs Lisp"
  homepage "https://github.com/purcell/elisp-slime-nav"
  url "https://github.com/purcell/elisp-slime-nav/archive/0.9.tar.gz"
  sha256 "6239d99fcdcfc819a7aa739f21eeea433493ea4bac909dfb3be91e8243f507ef"
  head "https://github.com/purcell/elisp-slime-nav.git"

  depends_on EmacsRequirement

  def install
    byte_compile "elisp-slime-nav.el"
    elisp.install "elisp-slime-nav.el", "elisp-slime-nav.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "elisp-slime-nav")
      (turn-on-elisp-slime-nav-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

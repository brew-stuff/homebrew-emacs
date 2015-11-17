require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class EvilNerdCommenter < EmacsFormula
  desc "Nerd Commenter emulation."
  homepage "https://github.com/redguardtoo/evil-nerd-commenter"
  url "https://github.com/redguardtoo/evil-nerd-commenter/archive/2.0.tar.gz"
  sha256 "fcd912b1142eb86fd29104270fedba8855d14bd611a92be1d53c8755b83b01f7"
  head "https://github.com/redguardtoo/evil-nerd-commenter.git"

  depends_on :emacs
  depends_on "evil" => :recommended

  def install
    byte_compile "evil-nerd-commenter.el"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'evil-nerd-commenter)
    (evilnc-default-hotkeys)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
                                   (add-to-list 'load-path "#{elisp}")
      (load "evil-nerd-commenter")
      (evilnc-default-hotkeys)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

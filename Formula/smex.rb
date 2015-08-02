require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Smex < EmacsFormula
  desc "Adds Ido completions to Emacs' M-x"
  homepage "https://github.com/nonsequitur/smex"
  url "https://github.com/nonsequitur/smex/archive/3.0.tar.gz"
  sha256 "96eb68ac3301d0986195a29ea03d4dad1a5f81647cb097a78de59c1cc6d78e58"
  head "https://github.com/nonsequitur/smex.git"

  depends_on :emacs => "24.1"

  def install
    byte_compile "smex.el"
    (share/"emacs/site-lisp/smex").install "smex.el", "smex.elc"
    doc.install "README.markdown"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'smex)
    (global-set-key (kbd "M-x") 'smex)
    (global-set-key (kbd "M-X") 'smex-major-mode-commands)
    (global-set-key (kbd "C-x C-M") 'smex-major-mode-commands)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (require 'smex)
      (smex-initialize)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

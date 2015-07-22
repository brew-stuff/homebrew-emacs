require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Keyfreq < EmacsFormula
  desc "Track Emacs command frequencies"
  homepage "https://github.com/dacap/keyfreq"
  url "https://github.com/dacap/keyfreq/archive/1.5.tar.gz"
  sha256 "c03ed5bcf506f0426c46be536a9b1b449e439f69f008a5175c6f9adecfb83201"
  head "https://github.com/dacap/keyfreq.git"

  depends_on :emacs

  def install
    byte_compile "keyfreq.el"
    (share/"emacs/site-lisp/keyfreq").install "keyfreq.el",
                                              "keyfreq.elc"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'keyfreq)
    (keyfreq-mode 1)
    (keyfreq-autosave-mode 1)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "keyfreq")
      (keyfreq-autosave-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

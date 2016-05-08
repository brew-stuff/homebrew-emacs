require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Keyfreq < EmacsFormula
  desc "Track Emacs command frequencies"
  homepage "https://github.com/dacap/keyfreq"
  url "https://github.com/dacap/keyfreq/archive/1.8.tar.gz"
  sha256 "8dd13c050e4ebb943c9190f2d9066ec6f4cb7af21b28abd1a2bc76c59539609e"
  head "https://github.com/dacap/keyfreq.git"

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile "keyfreq.el"
    elisp.install "keyfreq.el", "keyfreq.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/keyfreq")
      (load "keyfreq")
      (keyfreq-autosave-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

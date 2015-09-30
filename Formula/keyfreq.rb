require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Keyfreq < EmacsFormula
  desc "Track Emacs command frequencies"
  homepage "https://github.com/dacap/keyfreq"
  url "https://github.com/dacap/keyfreq/archive/1.7.tar.gz"
  sha256 "b933c3535b68b141f959aa352621d738bdd8bc16a952721674150cbb6f0e4b69"
  head "https://github.com/dacap/keyfreq.git"

  depends_on :emacs

  def install
    byte_compile "keyfreq.el"
    (share/"emacs/site-lisp/keyfreq").install "keyfreq.el",
                                              "keyfreq.elc"
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

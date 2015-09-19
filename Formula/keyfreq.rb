require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Keyfreq < EmacsFormula
  desc "Track Emacs command frequencies"
  homepage "https://github.com/dacap/keyfreq"
  url "https://github.com/dacap/keyfreq/archive/1.6.tar.gz"
  sha256 "ecf2ea7686842adb4052637444de6fe5325baab5c71b20f3965c2408a94e10c9"
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

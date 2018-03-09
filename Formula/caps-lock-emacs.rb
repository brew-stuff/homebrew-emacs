require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CapsLockEmacs < EmacsFormula
  desc "Caps lock as an Emacs minor mode"
  homepage "http://elpa.gnu.org/packages/caps-lock.html"
  url "http://elpa.gnu.org/packages/caps-lock-1.0.el"
  sha256 "6a5fba4a7fb30ce50050477639ed34bb76f2e374a7083417c88ddc80aae290c4"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/caps-lock/caps-lock.el"

  depends_on EmacsRequirement

  def install
    mv "caps-lock-#{version}.el", "caps-lock.el" if build.stable?

    byte_compile "caps-lock.el"
    (share/"emacs/site-lisp/caps-lock").install "caps-lock.el",
                                                "caps-lock.elc"
  end

  def caveats; <<~EOS
    Add the following to your init file:

    (require 'caps-lock)
  EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/caps-lock")
      (load "caps-lock")
      (print caps-lock-commands)
    EOS
    assert_equal "(self-insert-command isearch-printing-char)",
                 shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

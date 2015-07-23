require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Seq < EmacsFormula
  desc "Sequence manipulation library for Emacs"
  homepage "http://elpa.gnu.org/packages/seq.html"
  url "http://elpa.gnu.org/packages/seq-1.8.el"
  sha256 "9c2cd997a5d71c4b2661a28f4a53cce67f6cc9bb3a961abc726453813fc92b15"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/seq/seq.el"

  depends_on :emacs

  def install
    mv "seq-#{version}.el", "seq.el" if build.stable?

    byte_compile "seq.el"
    (share/"emacs/site-lisp/seq").install "seq.el", "seq.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "seq")
      (print (seq-max '(1 5 10)))
    EOS
    assert_equal "10", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

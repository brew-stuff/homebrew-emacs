require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Seq < EmacsFormula
  desc "Sequence manipulation library for Emacs"
  homepage "http://elpa.gnu.org/packages/seq.html"
  url "http://elpa.gnu.org/packages/seq-1.9.el"
  sha256 "08be71299d883c0a547444dc5fbfd7a55f0b74eb037dba32998e936e9ffb2219"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/seq/seq.el"

  depends_on :emacs

  def install
    mv "seq-#{version}.el", "seq.el" if build.stable?
    byte_compile "seq.el"
    (share/"emacs/site-lisp/seq").install "seq.el", "seq.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/seq")
      (load "seq")
      (print (seq-max '(1 5 10)))
    EOS
    assert_equal "10", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

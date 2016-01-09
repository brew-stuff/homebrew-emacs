require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class BeaconMode < EmacsFormula
  desc "Highlight the cursor when an Emacs window scrolls"
  homepage "https://github.com/Malabarba/beacon"
  url "http://elpa.gnu.org/packages/beacon-0.5.1.el"
  sha256 "44ea8964d19e3c68a1d9ce4494fb8de80cecadca8a0736699f43749a2fbefef7"
  head "https://github.com/Malabarba/beacon.git"

  depends_on :emacs
  depends_on "homebrew/emacs/seq" if Emacs.version < 25

  def install
    mv "beacon-#{version}.el", "beacon.el" if build.stable?

    byte_compile "beacon.el"
    (share/"emacs/site-lisp/beacon-mode").install "beacon.el", "beacon.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/beacon-mode")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/seq"].opt_share}/emacs/site-lisp/seq")
      (load "beacon")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

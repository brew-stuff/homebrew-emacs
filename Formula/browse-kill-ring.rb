require File.expand_path("../Homebrew/emacs_formula", __dir__)

class BrowseKillRing < EmacsFormula
  desc "Tool for examining kill history in Emacs"
  homepage "https://github.com/browse-kill-ring/browse-kill-ring"
  url "https://github.com/browse-kill-ring/browse-kill-ring/archive/2.0.0.tar.gz"
  sha256 "3323acad302516a644f43cf726a2b3ce1be873fa87ce60a5969e1ea761ac3b35"
  head "https://github.com/browse-kill-ring/browse-kill-ring.git"

  depends_on EmacsRequirement

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/browse-kill-ring").install Dir["*.el"],
                                                       Dir["*.elc"]
    doc.install "README.md"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/browse-kill-ring")
      (load "browse-kill-ring")
      (browse-kill-ring-default-keybindings)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

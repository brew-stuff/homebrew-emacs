require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Achievements < EmacsFormula
  desc "Makes learning Emacs into a game"
  homepage "https://bitbucket.org/gvol/emacs-achievements"
  head "https://bitbucket.org/gvol/emacs-achievements", :using => :hg

  depends_on :emacs
  depends_on "homebrew/emacs/keyfreq"

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/achievements").install Dir["*.el"],
                                                   Dir["*.elc"]
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'achievements)
  EOS
  end

  test do
    (testpath/".emacs.d/.achievements").write ""
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/achievements")
      (load "achievements")
      (print (achievements-list-achievements))
    EOS
    assert_match "ACHIEVEMENT UNLOCKED", shell_output("emacs -Q --batch -l #{testpath}/test.el 2>&1").strip
  end
end

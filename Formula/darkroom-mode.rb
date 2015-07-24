require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DarkroomMode < EmacsFormula
  desc "Emacs major mode to remove visual distractions"
  homepage "http://elpa.gnu.org/packages/darkroom.html"
  url "http://elpa.gnu.org/packages/darkroom-0.1.el"
  sha256 "5399b8c7c5f7c7121772736bca1022c5951995755027924c78a71f18aa432e3a"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/darkroom/darkroom.el"

  depends_on :emacs
  depends_on "dunn/emacs/cl-lib" if Emacs.version < 24.3

  def install
    mv "darkroom-#{version}.el", "darkroom.el"
    byte_compile "darkroom.el"
    (share/"emacs/site-lisp/darkroom").install "darkroom.el",
                                               "darkroom.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'darkroom)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "darkroom")
      (darkroom-tentative-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

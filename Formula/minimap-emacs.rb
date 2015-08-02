require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class MinimapEmacs < EmacsFormula
  desc "Emacs minor mode for sidebar displays of buffers"
  homepage "http://elpa.gnu.org/packages/minimap.html"
  url "http://elpa.gnu.org/packages/minimap-1.2.el"
  sha256 "68edade04864f7d04a7777922fc0cac3d3999caf73c49c298915ed7a7c6f9ded"

  depends_on :emacs

  def install
    mv "minimap-#{version}.el", "minimap.el"
    byte_compile "minimap.el"
    (share/"emacs/site-lisp/minimap").install "minimap.el",
                                              "minimap.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'minimap)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/minimap")
      (load "minimap")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

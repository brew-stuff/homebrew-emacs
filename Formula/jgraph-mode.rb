require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class JgraphMode < EmacsFormula
  desc "Emacs major mode for editing Jgraph files"
  homepage "http://elpa.gnu.org/packages/jgraph-mode.html"
  url "http://elpa.gnu.org/packages/jgraph-mode-1.1.el"
  sha256 "1469d74235c64e6baa2e48183b1167bb6afc029d8e0efaace9e9e4f2658ee910"

  depends_on :emacs
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    mv "jgraph-mode-#{version}.el", "jgraph-mode.el"
    byte_compile "jgraph-mode.el"
    (share/"emacs/site-lisp/jgraph-mode").install "jgraph-mode.el",
                                                  "jgraph-mode.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'jgraph-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/jgraph-mode")
      (load "jgraph-mode")
      (print jgraph-commands)
    EOS
    assert_match "epilogue", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

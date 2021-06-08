require File.expand_path("../Homebrew/emacs_formula", __dir__)

class DocbookEmacs < EmacsFormula
  desc "Emacs package for viewing DocBook files"
  homepage "http://elpa.gnu.org/packages/docbook.html"
  url "http://elpa.gnu.org/packages/docbook-0.1.el"
  sha256 "668706d1d52744295cce5c850f4de273eb256eea109b59d3fdb5180e1b7aa007"

  depends_on EmacsRequirement

  def install
    mv "docbook-#{version}.el", "docbook.el"
    byte_compile "docbook.el"
    (share/"emacs/site-lisp/docbook").install "docbook.el",
                                              "docbook.elc"
  end

  def caveats
    <<~EOS
      Add the following to your init file:

      (require 'docbook)
    EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/docbook")
      (load "docbook")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

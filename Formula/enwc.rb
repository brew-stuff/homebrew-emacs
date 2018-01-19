require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Enwc < EmacsFormula
  desc "The Emacs Network Client"
  homepage "http://elpa.gnu.org/packages/enwc.html"
  url "http://elpa.gnu.org/packages/enwc-1.0.tar"
  sha256 "1eedd7238722c71d6686afd636d36daabbbf2ecf5ee9562affcf33651f9bb2a6"
  head "http://bzr.savannah.nongnu.org/r/enwc/trunk", :using => :bzr

  depends_on EmacsRequirement
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    if build.stable?
      byte_compile Dir["*.el"]
      (share/"emacs/site-lisp/enwc").install Dir["*.el"], Dir["*.elc"]
    else
      # currently fails:
      # enwc-wicd.el:378:1:Error: Unknown upattern `(quote addr)'
      system "make"
      system "make", "install", "PREFIX=#{prefix}"
    end
    doc.install Dir["doc/*"]
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'enwc-setup)
    (enwc-setup)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/enwc")
      (load "enwc-setup")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

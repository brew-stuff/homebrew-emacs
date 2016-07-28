require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WisiEmacs < EmacsFormula
  desc "Indentation/navigation in Emacs using LALR parsers"
  homepage "https://elpa.gnu.org/packages/wisi.html"
  url "https://elpa.gnu.org/packages/wisi-1.1.3.tar"
  sha256 "53a5fb2685b5a31be719d14020920200aa8ee393f798834cde6f9ce7fb8b14ee"

  depends_on :emacs => "24.2"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "wisi")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

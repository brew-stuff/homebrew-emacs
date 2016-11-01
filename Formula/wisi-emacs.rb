require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WisiEmacs < EmacsFormula
  desc "Indentation/navigation in Emacs using LALR parsers"
  homepage "https://elpa.gnu.org/packages/wisi.html"
  url "https://elpa.gnu.org/packages/wisi-1.1.4.tar"
  sha256 "99507170b58aab866d7bbc63547751454227d68b196452f4bf7d5dbdcfc10bd8"

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

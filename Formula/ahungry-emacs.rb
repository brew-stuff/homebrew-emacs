require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AhungryEmacs < EmacsFormula
  desc "Bright and bold color theme for Emacs"
  homepage "https://github.com/ahungry/color-theme-ahungry"
  url "http://elpa.gnu.org/packages/ahungry-theme-1.0.9.tar"
  sha256 "8c5701ec1ef6f1df244005289322ac51f8543102bd266a89fd69aff99442b1e2"
  head "https://github.com/ahungry/color-theme-ahungry.git"

  depends_on :emacs => "24.1"

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/ahungry").install Dir["*.el"],
                                              Dir["*.elc"]
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (add-to-list 'custom-theme-load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/ahungry/")
    (load-theme 'ahungry t)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'custom-theme-load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp/ahungry/")
      (load-theme 'ahungry t)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AumixMode < EmacsFormula
  desc "Emacs major mode for controlling aumix in a buf"
  homepage "http://user42.tuxfamily.org/aumix-mode/index.html"
  url "http://download.tuxfamily.org/user42/elpa/packages/aumix-mode-7.el"
  sha256 "8b8ef69fcaa1abc9f4e3404d3c15e37bad1a7549022340fdfb2dfce933cb2904"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/aumix-mode/aumix-mode.el"

  depends_on EmacsRequirement => "20"

  def install
    mv "aumix-mode-#{version}.el", "aumix-mode.el" if build.stable?

    byte_compile "aumix-mode.el"
    (share/"emacs/site-lisp/aumix-mode").install "aumix-mode.el",
                                                 "aumix-mode.elc"
  end

  def caveats; <<~EOS
    Add the following to your init file:

    (autoload 'aumix "aumix-mode" nil t)
  EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/aumix-mode")
      (load "aumix-mode")
      (aumix-mode)
      (aumix-mode-quit)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

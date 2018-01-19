require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WcheckMode < EmacsFormula
  desc "General-purpose text-checker interface for Emacs"
  homepage "https://github.com/tlikonen/wcheck-mode"
  url "http://elpa.gnu.org/packages/wcheck-mode-2016.1.30.el"
  sha256 "58f6d43989214f44c61ea75a06bebf383f08c9e5c74b3b1080045047b5edf943"
  head "https://github.com/tlikonen/wcheck-mode.git"

  depends_on EmacsRequirement

  def install
    if build.stable?
      mv "wcheck-mode-#{version}.el", "wcheck-mode.el"
      byte_compile "wcheck-mode.el"
    else
      system "make", "elc"
    end

    elisp.install "wcheck-mode.el", "wcheck-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "wcheck-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

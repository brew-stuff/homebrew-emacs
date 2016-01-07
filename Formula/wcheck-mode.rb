require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WcheckMode < EmacsFormula
  desc "General-purpose text-checker interface for Emacs"
  homepage "https://github.com/tlikonen/wcheck-mode"
  url "http://elpa.gnu.org/packages/wcheck-mode-2016.1.5.el"
  sha256 "6349832400070833d697c2baf251450a452a54414f32edc9ef57ddc0b518ad2b"
  head "https://github.com/tlikonen/wcheck-mode.git"

  depends_on :emacs

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

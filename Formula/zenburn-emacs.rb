require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ZenburnEmacs < EmacsFormula
  desc "Low contrast theme for Emacs"
  homepage "https://github.com/bbatsov/zenburn-emacs"
  url "https://github.com/bbatsov/zenburn-emacs/archive/v2.3.tar.gz"
  sha256 "19289d14f58b4624975d20492b4c108feda904699e646a9afbfe9f76d0b10edc"
  head "https://github.com/bbatsov/zenburn-emacs.git"

  bottle :unneeded

  depends_on :emacs => "24.1"

  def install
    elisp.install "zenburn-theme.el"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'custom-theme-load-path "#{elisp}")
      (load-theme 'zenburn t)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

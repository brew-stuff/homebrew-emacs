require File.expand_path("../Homebrew/emacs_formula", __dir__)

class TempBufferBrowse < EmacsFormula
  desc "Emacs mode for navigating temporary buffers"
  homepage "https://elpa.gnu.org/packages/temp-buffer-browse.html"
  url "https://elpa.gnu.org/packages/temp-buffer-browse-1.5.el"
  sha256 "6c74cc2ac6b971f22d2e841a8179d1a21ffc7c58079d5e65749b3cc33ade2eb7"

  depends_on EmacsRequirement => "24.3"

  def install
    mv "temp-buffer-browse-#{version}.el", "temp-buffer-browse.el"
    byte_compile "temp-buffer-browse.el"
    elisp.install "temp-buffer-browse.el", "temp-buffer-browse.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "temp-buffer-browse")
      (temp-buffer-browse-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

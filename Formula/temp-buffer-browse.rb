require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TempBufferBrowse < EmacsFormula
  desc "Emacs mode for navigating temporary buffers"
  homepage "http://elpa.gnu.org/packages/temp-buffer-browse.html"
  url "http://elpa.gnu.org/packages/temp-buffer-browse-1.4.el"
  sha256 "9cd50b8e1450b3de78e3b72c9c26ea38fdccc0975041d366f8488b852a3cbf14"

  depends_on :emacs => "24.3"

  def install
    mv "temp-buffer-browse-#{version}.el", "temp-buffer-browse.el"
    byte_compile "temp-buffer-browse.el"
    (share/"emacs/site-lisp/temp-buffer-browse").install "temp-buffer-browse.el",
                                                         "temp-buffer-browse.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'temp-buffer-browse)
    (temp-buffer-browse-mode 1)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "temp-buffer-browse")
      (temp-buffer-browse-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

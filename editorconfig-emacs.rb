class EditorconfigEmacs < Formula
  desc "EditorConfig plugin for emacs"
  homepage "http://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-emacs/archive/v0.4.tar.gz"
  sha256 "763405eb475f328105c5772cc03023ba8faca83fb60745b1bc9613b1ea1acea6"
  head "https://github.com/editorconfig/editorconfig-emacs.git"

  depends_on "editorconfig"
  # developers only test it against 24
  depends_on :emacs => "24"

  def install
    system "make"
    system "make", "test"
    (share/"emacs/site-lisp/editorconfig-emacs").install "editorconfig.el",
                                                         "editorconfig.elc"
    doc.install "README.md"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/editorconfig-emacs")
      (load "editorconfig")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

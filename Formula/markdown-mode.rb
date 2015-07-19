class MarkdownMode < Formula
  desc "Major mode for editing Markdown files"
  homepage "http://jblevins.org/projects/markdown-mode/"
  url "http://jblevins.org/git/markdown-mode.git/snapshot/markdown-mode-2.0.tar.gz"
  sha256 "625e6f9680470bd119d79a3f97731347b8dd3d6311926f353d4065e67b76d92b"
  head "git://jblevins.org/git/markdown-mode.git"

  def install
    (share/"emacs/site-lisp/markdown-mode").install "markdown-mode.el"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (require 'markdown-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

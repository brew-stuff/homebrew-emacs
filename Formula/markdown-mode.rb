class MarkdownMode < Formula
  desc "Major mode for editing Markdown files"
  homepage "http://jblevins.org/projects/markdown-mode/"
  url "http://jblevins.org/git/markdown-mode.git/snapshot/markdown-mode-2.0.tar.gz"
  sha256 "625e6f9680470bd119d79a3f97731347b8dd3d6311926f353d4065e67b76d92b"
  head "git://jblevins.org/git/markdown-mode.git"

  option "with-markdown-plus", "Install the markdown-mode+ extension"

  resource "markdown+" do
    url "https://github.com/milkypostman/markdown-mode-plus/raw/f35e63284c5caed19b29501730e134018a78e441/markdown-mode%2B.el"
    sha256 "743209cb390f9bd29bbaaf53d8e4940ee452ce401d85f253d938503d0e80d0f8"
  end

  def install
    (share/"emacs/site-lisp/markdown-mode").install "markdown-mode.el"

    if build.with? "markdown-plus"
      resource("markdown+").stage do
        (share/"emacs/site-lisp/markdown-mode").install "markdown-mode%2B.el" => "markdown-mode+.el"
      end
    end
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

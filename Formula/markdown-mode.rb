require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class MarkdownMode < EmacsFormula
  desc "Major mode for editing Markdown files"
  homepage "http://jblevins.org/projects/markdown-mode/"
  url "http://jblevins.org/git/markdown-mode.git/snapshot/markdown-mode-2.0.tar.gz"
  sha256 "625e6f9680470bd119d79a3f97731347b8dd3d6311926f353d4065e67b76d92b"
  head "git://jblevins.org/git/markdown-mode.git"

  deprecated_option "with-markdown-plus" => "with-plus"

  option "with-plus", "Install the markdown-mode+ extension"
  option "with-toc", "Install the markdown-toc extension"

  depends_on :emacs

  if build.with? "toc"
    depends_on "dunn/emacs/s"
    depends_on "dunn/emacs/dash"
  end

  resource "markdown+" do
    url "https://github.com/milkypostman/markdown-mode-plus/raw/f35e63284c5caed19b29501730e134018a78e441/markdown-mode%2B.el"
    sha256 "743209cb390f9bd29bbaaf53d8e4940ee452ce401d85f253d938503d0e80d0f8"
  end

  resource "markdown-toc" do
    url "https://github.com/ardumont/markdown-toc/releases/download/0.0.8/markdown-toc-0.0.8.tar"
    sha256 "41369e5e2715672ead1570714c3f3aedce2e8c754b817b78c521405bf0349639"
  end

  def install
    if build.with? "plus"
      resource("markdown+").stage do
        mv "markdown-mode%2B.el", "markdown-mode+.el"
        byte_compile "markdown-mode+.el"
        (share/"emacs/site-lisp/markdown-mode").install "markdown-mode+.el",
                                                        "markdown-mode+.elc"
      end
    end
    if build.with? "toc"
      resource("markdown-toc").stage do
        byte_compile "markdown-toc.el"
        (share/"emacs/site-lisp/markdown-mode").install "markdown-toc.el",
                                                        "markdown-toc.elc"
      end
    end

    # Install markdown-mode last so it's in the buildpath when
    # markdown-toc looks for it during compile
    #
    # markdown-mode itself currently fails to compile:
    # > markdown-mode.el:3737:1:Error: Invalid modifier in string
    (share/"emacs/site-lisp/markdown-mode").install "markdown-mode.el"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'markdown-mode)
    (add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))
    (add-to-list 'auto-mode-alist '("\\.mdown$" . markdown-mode))
    (add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
  EOS
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

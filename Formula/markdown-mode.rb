require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class MarkdownMode < EmacsFormula
  desc "Major mode for editing Markdown files"
  homepage "http://jblevins.org/projects/markdown-mode/"
  url "https://github.com/jrblevin/markdown-mode/archive/v2.1.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/markdown-mode/markdown-mode_2.1.orig.tar.gz"
  sha256 "65d28802915a47056108b63eba3911e32de35c5d6b3c6898ca23ac414b0c4de7"
  head "https://github.com/jrblevin/markdown-mode.git"

  deprecated_option "with-markdown-plus" => "with-plus"

  option "with-plus", "Install the markdown-mode+ extension"
  option "with-toc", "Install the markdown-toc extension"

  depends_on :emacs => "24.4"

  if build.with? "toc"
    depends_on "homebrew/emacs/s-emacs"
    depends_on "homebrew/emacs/dash-emacs"
  end

  resource "markdown+" do
    url "https://github.com/milkypostman/markdown-mode-plus/raw/f35e63284c5caed19b29501730e134018a78e441/markdown-mode%2B.el"
    sha256 "743209cb390f9bd29bbaaf53d8e4940ee452ce401d85f253d938503d0e80d0f8"
  end

  resource "markdown-toc" do
    url "https://github.com/ardumont/markdown-toc/releases/download/0.1.1/markdown-toc-0.1.1.tar"
    sha256 "40d1297e2c9cbb38aad10c7431f1ea1ffc09c97aefa4e6d96adde3fd1e1a27ad"
  end

  def install
    if build.with? "plus"
      resource("markdown+").stage do
        mv "markdown-mode%2B.el", "markdown-mode+.el"
        byte_compile "markdown-mode+.el"
        elisp.install "markdown-mode+.el", "markdown-mode+.elc"
      end
    end
    if build.with? "toc"
      resource("markdown-toc").stage do
        byte_compile "markdown-toc.el"
        elisp.install "markdown-toc.el", "markdown-toc.elc"
      end
    end

    # Install markdown-mode last so it's in the buildpath when
    # markdown-toc looks for it during compile
    byte_compile "markdown-mode.el"
    elisp.install "markdown-mode.el", "markdown-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (require 'markdown-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

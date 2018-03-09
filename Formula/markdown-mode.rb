require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class MarkdownMode < EmacsFormula
  desc "Major mode for editing Markdown files"
  homepage "https://jblevins.org/projects/markdown-mode/"
  url "https://github.com/jrblevin/markdown-mode/archive/v2.3.tar.gz"
  sha256 "a309492fa01fac6ca75d2abc5ccac6bf459578fa273b42a348df37e8f0978cd3"
  head "https://github.com/jrblevin/markdown-mode.git"

  deprecated_option "with-markdown-plus" => "with-plus"

  option "with-plus", "Install the markdown-mode+ extension"
  option "with-toc", "Install the markdown-toc extension"

  depends_on EmacsRequirement => "24.4"

  if build.with? "toc"
    depends_on "dunn/emacs/s-emacs"
    depends_on "dunn/emacs/dash-emacs"
  end

  resource "markdown-plus" do
    url "https://github.com/milkypostman/markdown-mode-plus/raw/411d079f4430a33c34ec0bbcb1535fe1145a2509/markdown-mode%2B.el"
    sha256 "771a3015d5cf8999a656f1e1a25c6bf2fce7d10d1ecccaae6dd3dfe664999db9"
  end

  resource "markdown-toc" do
    url "https://github.com/ardumont/markdown-toc/releases/download/0.1.2/markdown-toc-0.1.2.tar"
    sha256 "6f2ac775a0bd6986f916bbc4051300536b390e19101300fc95235b091dfbb8c2"
  end

  def install
    if build.with? "plus"
      resource("markdown-plus").stage do
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

    # One of the tests tries to do a recursive read of TMPDIR, which
    # fails because of the sandbox
    ENV["TMPDIR"] = buildpath

    # Install markdown-mode last so it's in the buildpath when
    # markdown-toc looks for it during compile
    system "make", "test"
    system "make"
    elisp.install "markdown-mode.el", "markdown-mode.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (require 'markdown-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

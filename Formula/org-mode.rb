require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class OrgMode < EmacsFormula
  desc "Notes, TODOs, and project planning for Emacs"
  homepage "http://orgmode.org"
  url "http://orgmode.org/org-9.1.4.tar.gz"
  sha256 "7e38e84527b844e822a715f970c7ff135af40666b0a53e432dca2cb3e7222981"
  head "http://orgmode.org/org-mode.git", :shallow => false

  bottle :disable

  option "with-texinfo-plus", "Build with ox-texinfo+"
  option "with-toc", "Build with toc-org"

  depends_on EmacsRequirement => "24.3"
  depends_on "dunn/emacs/dash-emacs"

  resource "ox-texinfo-plus" do
    url "https://github.com/tarsius/ox-texinfo-plus/archive/v2.2.0.tar.gz"
    sha256 "0d4d73208700b812b9bf79d9fb83945eafff317f82dc0cbe2aa8aba4fa87a85d"
  end

  resource "toc-org" do
    url "https://github.com/snosov1/toc-org/archive/1.0.1.tar.gz"
    sha256 "8a6fa8c632d8a00eb040df1303717a13e870668f1ce43f384d1ab9ad4d4d4318"
  end

  def install
    if build.with? "texinfo-plus"
      resource("ox-texinfo-plus").stage do
        byte_compile "ox-texinfo+.el"
        elisp.install "ox-texinfo+.el", "ox-texinfo+.elc"
      end
    end

    if build.with? "toc"
      resource("toc-org").stage do
        byte_compile "toc-org.el"
        elisp.install "toc-org.el", "toc-org.elc"
      end
    end

    system "make", "all"

    rm "local.mk"
    (buildpath/"local.mk").write <<~EOS
      prefix  = #{prefix}
      lispdir = #{elisp}
      datadir = #{etc}/emacs/#{name}
      infodir = #{info}/emacs/#{name}
    EOS

    system "make", "install"

    elisp.install "contrib/lisp" => "contrib"
    info.install "doc/org" => "org.info"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "org")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

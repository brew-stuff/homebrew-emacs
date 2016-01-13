require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class OrgMode < EmacsFormula
  desc "Notes, TODOs, and project planning for Emacs"
  homepage "http://orgmode.org"
  url "http://orgmode.org/org-8.3.3.tar.gz"
  sha256 "c560064ab9a52ac682ce452c62fee90113e67e9950b67e0ab1eaec405aad1eee"

  head "git://orgmode.org/org-mode.git", :shallow => false

  option "with-texinfo-plus", "Install Jonas Bernoulli's extension of ox-texinfo"
  option "with-toc", "Install the toc-org extension"

  depends_on :emacs
  depends_on :tex => :optional
  depends_on "homebrew/emacs/dash-emacs"

  resource "ox-texinfo-plus" do
    url "https://github.com/tarsius/ox-texinfo-plus/raw/9074ab2a22cb13536b8c19f69480c8723c91a2b6/ox-texinfo%2B.el"
    sha256 "d358d3c30d377f0ba831be8df79884de2bb571f875c78a0d1d1cc93282fe4d93"
    version "20151203"
  end

  resource "toc-org" do
    url "https://raw.githubusercontent.com/snosov1/toc-org/72883a08b01d08b74cc03c565eac8d0422770fcf/toc-org.el"
    sha256 "7da964e6060a11fd6ddcd86cd30a7cfb1dca0e54eb452eaf16ef660895aa8c8f"
    version "20150921"
  end

  def install
    system "make", "all"
    rm "local.mk"
    (buildpath/"local.mk").write <<-EOS.undent
      prefix  = #{prefix}
      lispdir = #{elisp}
      datadir = #{etc}/emacs/#{name}
      infodir = #{info}/emacs/#{name}
    EOS
    system "make", "install"

    if build.with? "texinfo-plus"
      resource("ox-texinfo-plus").stage do
        mv "ox-texinfo%2B.el", "ox-texinfo+.el"
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

    elisp.install "contrib/lisp" => "contrib"
    info.install "doc/org" => "org.info"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "org")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

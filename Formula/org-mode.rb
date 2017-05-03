require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class OrgMode < EmacsFormula
  desc "Notes, TODOs, and project planning for Emacs"
  homepage "http://orgmode.org"
  url "http://orgmode.org/org-9.0.6.tar.gz"
  sha256 "3974fc2ae45000eda65dac37ad2d27055c8354ec1fe6155770284f300bf7cc85"
  head "http://orgmode.org/org-mode.git", :shallow => false

  bottle :disable

  option "with-texinfo-plus", "Install Jonas Bernoulli's extension of ox-texinfo"
  option "with-toc", "Install the toc-org extension"

  depends_on :emacs => "24.3"
  depends_on "dunn/emacs/dash-emacs"

  resource "ox-texinfo-plus" do
    url "https://github.com/tarsius/ox-texinfo-plus/archive/v1.2.0.tar.gz"
    sha256 "f18f84c2a5e80a70897ca0cec1338bf327122c8b1894bdd0290dc2ab6348e85b"
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
    (buildpath/"local.mk").write <<-EOS.undent
      prefix  = #{prefix}
      lispdir = #{elisp}
      datadir = #{etc}/emacs/#{name}
      infodir = #{info}/emacs/#{name}
    EOS

    system "make", "install"

    cd "contrib/lisp" do
      # htmlize has its own formula
      rm "htmlize.el"
      byte_compile Dir["*.el"]
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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class OrgMode < EmacsFormula
  desc "Notes, TODOs, and project planning for Emacs"
  homepage "http://orgmode.org"
  url "http://orgmode.org/org-8.3.4.tar.gz"
  sha256 "e86d9ce32b26ee31c954c9a6210422c65ecbe89129003d426a7fa4b1a8864603"

  head "git://orgmode.org/org-mode.git", :shallow => false

  option "with-texinfo-plus", "Install Jonas Bernoulli's extension of ox-texinfo"
  option "with-toc", "Install the toc-org extension"

  depends_on :emacs
  depends_on :tex => :optional
  depends_on "homebrew/emacs/dash-emacs"

  resource "ox-texinfo-plus" do
    url "https://github.com/tarsius/ox-texinfo-plus/raw/d8ccdda026aa6891a306288e51ce8a9436000889/ox-texinfo%2B.el"
    sha256 "cc734205aae4a1bb62e40b4c80b07362d2b0f1e8dff47a1b9ea1987521a8df02"
    version "20160408"
  end

  resource "toc-org" do
    url "https://github.com/snosov1/toc-org/archive/1.0.0.tar.gz"
    sha256 "57b71f5302f5063f9e80210b6fd188a53da4a0d14f3e55f6316790e12a70c1be"
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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class OrgMode < EmacsFormula
  desc "Notes, TODOs, and project planning for Emacs"
  homepage "http://orgmode.org"
  url "http://orgmode.org/org-9.0.1.tar.gz"
  sha256 "0b6087cf9a955bc507b69d620c6461a44976479bcd9c31405c1c033348b9b6f7"

  head "http://orgmode.org/org-mode.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "30bf2868997c48e7ce1f83cf7c6cad16afbb9b764033074784635c23d03e6e64" => :sierra
    sha256 "28ddf65bbbc3bfbc261673b99556f020269f9ea0ccb66007da743a519fa26b57" => :el_capitan
    sha256 "26e8ac99dedc1673808e8acd8fd3795ad7eef19f5a65838c7e4e62d311d9df0e" => :yosemite
  end

  option "with-texinfo-plus", "Install Jonas Bernoulli's extension of ox-texinfo"
  option "with-toc", "Install the toc-org extension"

  depends_on :emacs => "24.3"
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

    system "make", "all"

    rm "local.mk"
    (buildpath/"local.mk").write <<-EOS.undent
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
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "org")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

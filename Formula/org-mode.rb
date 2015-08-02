require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class OrgMode < EmacsFormula
  desc "Notes, TODOs, and project planning for Emacs"
  homepage "http://orgmode.org"
  url "http://orgmode.org/org-8.2.10.tar.gz"
  sha256 "df09451829219f4ff25185670823ad319f96839962b44b6836c78ccc3fb2a8f6"

  head "git://orgmode.org/org-mode.git", :shallow => false

  devel do
    url "git://orgmode.org/org-mode.git",
        :shallow => false,
        :tag => "release_8.3beta",
        :revision => "4a4dbe16d82b4c8d441e79358003577c1ffdb440"
    version "8.3beta"
  end

  option "with-texinfo-plus", "Install Jonas Bernoulli's extension of ox-texinfo"
  option "with-toc", "Install the toc-org extension"

  depends_on :emacs
  depends_on :tex => :optional
  depends_on "dunn/emacs/dash"

  resource "ox-texinfo-plus" do
    url "https://github.com/tarsius/ox-texinfo-plus/raw/4e3c611ce8b79593171593d2907e0f95ae5c97fc/ox-texinfo%2B.el"
    sha256 "b4d3e376b361dbf24db33b542928f8b5c7acb13325b9a970dacb3ca50a83bbd5"
    version "20150319"
  end

  resource "toc-org" do
    url "https://raw.githubusercontent.com/snosov1/toc-org/8cf236450b25f5b655f3262564d5a6af325bf6f4/toc-org.el"
    sha256 "78432262ec6087a9eb0ac5062d6495258915c320e20e104ed633b392492cc21e"
    version "20150801"
  end

  def install
    system "make", "all"
    rm "local.mk"
    (buildpath/"local.mk").write <<-EOS.undent
      prefix  = #{prefix}
      lispdir = #{share}/emacs/site-lisp/#{name}
      datadir = #{etc}/emacs/#{name}
      infodir = #{info}/emacs/#{name}
    EOS
    system "make", "install"

    if build.with? "texinfo-plus"
      resource("ox-texinfo-plus").stage do
        mv "ox-texinfo%2B.el", "ox-texinfo+.el"
        byte_compile "ox-texinfo+.el"
        (share/"emacs/site-lisp/#{name}").install "ox-texinfo+.el",
                                                  "ox-texinfo+.elc"
      end
    end

    if build.with? "toc"
      resource("toc-org").stage do
        byte_compile "toc-org.el"
        (share/"emacs/site-lisp/#{name}").install "toc-org.el",
                                                  "toc-org.elc"
      end
    end

    (share/"emacs/site-lisp/#{name}").install "contrib/lisp" => "contrib"
    info.install "doc/org" => "org.info"
  end

  def caveats
    s = <<-EOS.undent
      Make sure the path to this version of org appears in your load-path before the version bundled with Emacs.

      Add the following to your init file:

      (require 'org)
      (add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
    EOS
    s += "(require 'ox-texinfo+)" if build.with? "texinfo-plus"
    if build.with? "toc"
      s += <<-EOS.undent
        (if (require 'toc-org nil t)
            (add-hook 'org-mode-hook 'toc-org-enable)
          (warn "toc-org not found"))
      EOS
    end
    s
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "org")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

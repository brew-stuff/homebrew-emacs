require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Magit < EmacsFormula
  desc "Emacs interface for Git"
  homepage "https://magit.vc/"
  url "https://github.com/magit/magit/releases/download/2.12.0/magit-2.12.0.tar.gz"
  sha256 "e26949084481a851e7ac580c898f34a51f05c7dc7bed8531afe9b324184c7ccb"
  head "https://github.com/magit/magit.git", :shallow => false

  bottle :disable

  option "with-gh-pulls", "Build with GitHub pull request extension"

  depends_on EmacsRequirement => "24.4"
  depends_on "dunn/emacs/async-emacs"
  depends_on "dunn/emacs/dash-emacs"

  if build.with? "gh-pulls"
    depends_on "dunn/emacs/gh-emacs"
    depends_on "dunn/emacs/pcache"
    depends_on "dunn/emacs/s-emacs"
  end

  resource "gh-pulls" do
    url "https://github.com/sigma/magit-gh-pulls/archive/0.5.3.tar.gz"
    sha256 "23d90e5aca234f856e7c6b622314dde03fa84910bc350da3b7e12b18796a4137"
  end

  resource "ghub" do
    url "https://github.com/magit/ghub/archive/v2.0.0.tar.gz"
    sha256 "6c77664c36258a5af756781c0c8c9cba8f069a001974a8c443422802661f2bff"
  end

  resource "popup" do
    url "https://github.com/magit/magit-popup/archive/v2.12.3.tar.gz"
    sha256 "69e46652e3d96457ed6e73998f40b57fd408051dd5482e7c727c72758cdce6cf"
  end

  resource "with-editor" do
    url "https://github.com/magit/with-editor/archive/v2.7.2.tar.gz"
    sha256 "bb0addd744f443ed2b3494f3316ad6d7ec049460bdcbb0d90d8b01cdba1a11cb"
  end

  def install
    resource("ghub").stage do
      system "make", "all"
      elisp.install "ghub.el", "ghub.elc"
      info.install "ghub.info"
    end

    resource("popup").stage do
      system "make", "all",
             "LOAD_PATH=-L #{Formula["dunn/emacs/async-emacs"].opt_elisp} \
                        -L #{Formula["dunn/emacs/dash-emacs"].opt_elisp}"
      elisp.install "magit-popup.el", "magit-popup.elc"
      info.install "magit-popup.info"
    end

    resource("with-editor").stage do
      system "make", "all",
             "EFLAGS=-L #{Formula["dunn/emacs/async-emacs"].opt_elisp} \
                     -L #{Formula["dunn/emacs/dash-emacs"].opt_elisp}"
      elisp.install "with-editor.el", "with-editor.elc"
      info.install "with-editor.info"
    end

    if build.with? "gh-pulls"
      resource("gh-pulls").stage do
        ert_run_tests "magit-gh-pulls-tests.el"
        byte_compile "magit-gh-pulls.el"
        elisp.install "magit-gh-pulls.el", "magit-gh-pulls.elc"
      end
    end

    load_args = [
      "LOAD_PATH = -L #{buildpath}/lisp",
      "LOAD_PATH += -L #{Formula["dunn/emacs/dash-emacs"].opt_elisp}",
      "LOAD_PATH += -L #{Formula["dunn/emacs/async-emacs"].opt_elisp}",
      "LOAD_PATH += -L #{elisp}",
    ]
    (buildpath/"config.mk").write load_args.join("\n")

    args = %W[
      PREFIX=#{prefix}
      docdir=#{doc}
    ]
    args << "VERSION=#{version}" if build.stable?
    system "make", "install", *args
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/async-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/dash-emacs"].opt_elisp}")
      (load "magit")
      (magit-init "#{testpath}")
    EOS
    system "emacs", "--batch", "-Q", "-l", "#{testpath}/test.el"
    assert (testpath/".git").directory?
  end
end

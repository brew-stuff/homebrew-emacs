require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Magit < EmacsFormula
  desc "Emacs interface for Git"
  homepage "https://github.com/magit/magit"
  url "https://github.com/magit/magit/releases/download/2.5.0/magit-2.5.0.tar.gz"
  sha256 "aaebcea4317c5f3a92f4d106e5196e5803171f6251c1c69c9f84fdaf4bbfd844"
  head "https://github.com/magit/magit.git", :shallow => false

  option "with-gh-pulls", "Build with GitHub pull request extension"

  depends_on :emacs => "24.4"
  depends_on "homebrew/emacs/async-emacs"
  depends_on "homebrew/emacs/dash-emacs"

  if build.with? "gh-pulls"
    depends_on "homebrew/emacs/gh-emacs"
    depends_on "homebrew/emacs/pcache"
    depends_on "homebrew/emacs/s"
  end

  resource "gh-pulls" do
    url "https://github.com/sigma/magit-gh-pulls/archive/0.5.2.tar.gz"
    sha256 "95cea18d4d9b8b16c64d726c24343280fa50705b057790d6cee6019ef3471037"
  end

  resource "with-editor" do
    url "https://github.com/magit/with-editor/archive/v2.5.0.tar.gz"
    sha256 "8091465eefee4057a4a0daab72db1f2f0415e2abfe965d1e8b8206f3031aeba5"
  end

  def install
    resource("with-editor").stage do
      byte_compile "with-editor.el"
      elisp.install "with-editor.el", "with-editor.elc"
      info.install "with-editor.info"
      doc.install Dir["with-editor.*"]
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
      "LOAD_PATH += -L #{Formula["homebrew/emacs/dash-emacs"].opt_elisp}",
      "LOAD_PATH += -L #{Formula["homebrew/emacs/async-emacs"].opt_elisp}",
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
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/async-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (load "magit")
      (magit-run-git "init")
    EOS
    system "emacs", "--batch", "-Q", "-l", "#{testpath}/test.el"
    assert (testpath/".git").directory?
  end
end

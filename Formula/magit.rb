require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Magit < EmacsFormula
  desc "Emacs interface for Git"
  homepage "https://magit.vc/"
  url "https://github.com/magit/magit/releases/download/2.10.1/magit-2.10.1.tar.gz"
  sha256 "5b9e690c9b679d5ae43de19dadcebaa7727b4f9f2359dc7c0b337f40b3d26fa8"
  head "https://github.com/magit/magit.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "8c63d377fb3097bf1cb1cef15778bf43d85801d77b3801cd3951291443728435" => :sierra
    sha256 "821734d9aa2c1896ed422aa6f7f1c2d654a044e428fdf29162d82d0b5ce18fae" => :el_capitan
    sha256 "0dfd0405f1a33e7126937d835138049763a80bf4160138c5586624e9dcff286a" => :yosemite
  end

  option "with-gh-pulls", "Build with GitHub pull request extension"

  depends_on :emacs => "24.4"
  depends_on "homebrew/emacs/async-emacs"
  depends_on "homebrew/emacs/dash-emacs"

  if build.with? "gh-pulls"
    depends_on "homebrew/emacs/gh-emacs"
    depends_on "homebrew/emacs/pcache"
    depends_on "homebrew/emacs/s-emacs"
  end

  resource "gh-pulls" do
    url "https://github.com/sigma/magit-gh-pulls/archive/0.5.2.tar.gz"
    sha256 "95cea18d4d9b8b16c64d726c24343280fa50705b057790d6cee6019ef3471037"
  end

  resource "with-editor" do
    url "https://github.com/magit/with-editor/archive/v2.5.9.tar.gz"
    sha256 "f0772410e280cf7926d145bcc8c43643141afefa3aa97fa2cfc08c8cbdfdce7e"
  end

  def install
    resource("with-editor").stage do
      system "make", "all",
             "EFLAGS=-L #{Formula["homebrew/emacs/async-emacs"].opt_elisp} \
                     -L #{Formula["homebrew/emacs/dash-emacs"].opt_elisp}"
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

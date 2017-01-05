require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Magit < EmacsFormula
  desc "Emacs interface for Git"
  homepage "https://magit.vc/"
  url "https://github.com/magit/magit/releases/download/2.10.0/magit-2.10.0.tar.gz"
  sha256 "a195a6dfc670d8fb65c55a5daa5840245ec9cfb379ca77b49b42a46f88dfe4f0"
  head "https://github.com/magit/magit.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "5e418f5bf3b925662622fa0a7bab1baac6843810e6e257a6bc090180b67b6bc5" => :sierra
    sha256 "8387ef26921f4e16f29089f8eac812807dcc630d7b9c9c91422064049eff2565" => :el_capitan
    sha256 "b7abc9fde948412d40cadf5bf3b645ca8c1dc8d520e4ed4ee30d74d88ecb2888" => :yosemite
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

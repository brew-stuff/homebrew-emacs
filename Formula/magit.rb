require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Magit < EmacsFormula
  desc "Emacs interface for Git"
  homepage "https://magit.vc/"
  url "https://github.com/magit/magit/releases/download/2.9.0/magit-2.9.0.tar.gz"
  sha256 "ac69c709dd6fe09b29dde1e8d98087058b869064cbbbf98effab7ebb1f4925cd"
  head "https://github.com/magit/magit.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e662ef4ccd434f9633e6e7123b6d5bc5ef2dc77021c260788a1cfc0cead1b57e" => :sierra
    sha256 "f3f27dd4d4ac9e89443e8165543051dc53f3a3192a30a2550ee363bbfc4ede2a" => :el_capitan
    sha256 "c66f3669225b268351971099b17cbd0c83fe61d7b82c6d99413fba602b70153a" => :yosemite
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
    url "https://github.com/magit/with-editor/archive/v2.5.5.tar.gz"
    sha256 "e4849370225f7e5973e6c4b4be6e5461d658ae58918079505c7d9fdbd436be25"
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

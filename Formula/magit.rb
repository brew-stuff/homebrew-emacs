require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Magit < EmacsFormula
  desc "Emacs interface for Git"
  homepage "https://magit.vc/"
  url "https://github.com/magit/magit/releases/download/2.8.0/magit-2.8.0.tar.gz"
  sha256 "d8415fe85d92edfa01fb2ce6238ba0e17a23d3a5e4f28f5d84d9466ee359dbfe"
  head "https://github.com/magit/magit.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "cec5a3dc927f808a2dc756302a6c70dc2ae945be4d26fc1633829260ee447522" => :el_capitan
    sha256 "b25d64ea860c9714ef6f43b569ca7d3617c140b2328d01acf88c3e7989d454bb" => :yosemite
    sha256 "23e5fdf303b38153b052f5c195bcd8569928126d6d361e14b18f40a4fdcbf1b4" => :mavericks
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
    url "https://github.com/magit/with-editor/archive/v2.5.3.tar.gz"
    sha256 "62fef0b3f22f1ecde39448aa6ef19899e3e2152f52847d6ada2f1b9d7123715f"
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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Magit < EmacsFormula
  desc "Emacs interface for Git"
  homepage "https://magit.vc/"
  url "https://github.com/magit/magit/releases/download/2.11.0/magit-2.11.0.tar.gz"
  sha256 "1f9ae73637257987a7c4ed60e78df0e14f1459c60b3ba4a10c4c265557f1b487"
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
    url "https://github.com/sigma/magit-gh-pulls/archive/0.5.2.tar.gz"
    sha256 "95cea18d4d9b8b16c64d726c24343280fa50705b057790d6cee6019ef3471037"
  end

  resource "with-editor" do
    url "https://github.com/magit/with-editor/archive/v2.6.0.tar.gz"
    sha256 "8f26a619d745f0a47281fd389c6f947733752472eec26a2b1d5e7f641063ea04"
  end

  def install
    resource("with-editor").stage do
      system "make", "all",
             "EFLAGS=-L #{Formula["dunn/emacs/async-emacs"].opt_elisp} \
                     -L #{Formula["dunn/emacs/dash-emacs"].opt_elisp}"
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
    (testpath/"test.el").write <<-EOS.undent
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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AutoComplete < EmacsFormula
  desc "Autocompletion extension for Emacs"
  homepage "https://github.com/auto-complete/auto-complete"
  url "https://github.com/auto-complete/auto-complete/archive/v1.5.0.tar.gz"
  sha256 "a960848fcb94f438c6795070b3125c1a039bf11cc058dbd60e8668adb3cebe4c"
  head "https://github.com/auto-complete/auto-complete.git"

  option "with-c-headers", "Install ac-c-headers"
  option "with-emoji", "Install ac-emoji"
  option "with-etags", "Install ac-etags"
  option "with-haskell", "Install ac-haskell-process"
  option "with-helm", "Use helm for selecting completion candidates"
  option "with-html", "Install ac-html"
  option "with-ispell", "Install ac-ispell"
  option "with-js2", "Install ac-js2"
  option "with-php", "Install ac-php"
  option "with-slime", "Install ac-slime"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/popup"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  depends_on "homebrew/emacs/haskell-mode" if build.with? "haskell"
  depends_on "homebrew/emacs/helm" if build.with? "helm"
  depends_on "homebrew/emacs/slime" if build.with? "slime"

  if build.with? "html"
    depends_on "homebrew/emacs/dash-emacs"
    depends_on "homebrew/emacs/web-completion-data"
  end

  if build.with? "js2"
    depends_on "homebrew/emacs/js2-mode"
    depends_on "homebrew/emacs/skewer-mode"
  end

  if build.with? "php"
    depends_on "homebrew/emacs/f"
    depends_on "homebrew/emacs/php-mode"
    depends_on "homebrew/emacs/s"
    depends_on "homebrew/emacs/xcscope"
    depends_on "homebrew/emacs/yasnippet"
  end

  resource "c-headers" do
    url "https://github.com/zk-phi/ac-c-headers.git",
        :revision => "2e9ace7f31e029c3c79a675e36d67279b11c6de5"
  end

  resource "emoji" do
    url "https://github.com/syohex/emacs-ac-emoji/archive/0.02.tar.gz"
    sha256 "fde5b02f594a212fd1bb8ef760ed4bb07d0ef00ef9f6608867b73c191ddf6127"
  end

  resource "etags" do
    url "https://github.com/syohex/emacs-ac-etags/archive/0.06.tar.gz"
    sha256 "23a22bdd8f25a783671bd9c00b0c5e4199e2b02bfb6cbecb6c8e5106a1d37f44"
  end

  resource "haskell" do
    url "https://github.com/purcell/ac-haskell-process/archive/0.7.tar.gz"
    sha256 "591eb00430da2b0418f8c445b67ba23259f970786be8a64732d0a01c4c9135aa"
  end

  resource "html" do
    url "https://github.com/cheunghy/ac-html/archive/v0.31.tar.gz"
    sha256 "759e2f0b91ea2babe41fd87fee079e897849966eb79b47e61bcadcb1ae9fbf42"
  end

  resource "helm" do
    url "https://github.com/yasuyk/ac-helm/archive/2.1.tar.gz"
    sha256 "38daf0810b82da129f6adbe4a955d819e25bda6a9b75dc2a96332ef4a237fb61"
  end

  resource "ispell" do
    url "https://github.com/syohex/emacs-ac-ispell/archive/0.07.tar.gz"
    sha256 "fe9f63ea435a888aa909bcb92435957ab8472e6bce33cbabc51f2f00d5e6a893"
  end

  resource "js2" do
    url "https://github.com/ScottyB/ac-js2.git",
        :revision => "721c482e1d4a08f4a29a74437257d573e8f69969"
  end

  resource "php" do
    url "https://github.com/xcwen/ac-php/archive/1.5.1.tar.gz"
    sha256 "6de2d559d96783f07dec1a2941569aae6f44b093a1ec620444370388d6ec9077"
  end

  resource "slime" do
    url "https://github.com/purcell/ac-slime/archive/0.8.tar.gz"
    sha256 "c33d8098708899f103d4b50daf45f3fb6d8e8ae57a912ece5c682da86afe0540"
  end

  def install
    if build.with? "c-headers"
      resource("c-headers").stage do
        byte_compile "ac-c-headers.el"
        (share/"emacs/site-lisp/auto-complete/ac-c-headers").install "ac-c-headers.el", "ac-c-headers.elc"
      end
    end

    if build.with? "emoji"
      resource("emoji").stage do
        byte_compile Dir["*.el"]
        (share/"emacs/site-lisp/auto-complete/ac-emoji").install Dir["*.el"], Dir["*.elc"]
      end
    end

    if build.with? "etags"
      resource("etags").stage do
        byte_compile "ac-etags.el"
        (share/"emacs/site-lisp/auto-complete/ac-etags").install "ac-etags.el", "ac-etags.elc"
      end
    end

    if build.with? "haskell"
      resource("haskell").stage do
        byte_compile "ac-haskell-process.el"
        (share/"emacs/site-lisp/auto-complete/ac-haskell-process").install "ac-haskell-process.el", "ac-haskell-process.elc"
      end
    end

    if build.with? "helm"
      resource("helm").stage do
        byte_compile "ac-helm.el"
        (share/"emacs/site-lisp/auto-complete/ac-helm").install "ac-helm.el", "ac-helm.elc"
      end
    end

    if build.with? "html"
      resource("html").stage do
        ert_run_tests "test/run-test.el"
        byte_compile Dir["*.el"]
        (share/"emacs/site-lisp/auto-complete/ac-html").install Dir["*.el"], Dir["*.elc"]
      end
    end

    if build.with? "ispell"
      resource("ispell").stage do
        byte_compile "ac-ispell.el"
        (share/"emacs/site-lisp/auto-complete/ac-ispell").install "ac-ispell.el", "ac-ispell.elc"
      end
    end

    if build.with? "js2"
      resource("js2").stage do
        byte_compile "ac-js2.el"
        (share/"emacs/site-lisp/auto-complete/ac-js2").install "ac-js2.el", "ac-js2.elc", "skewer-addon.js"
      end
    end

    if build.with? "php"
      resource("php").stage do
        ert_run_tests "tests/ac-php-test.el"
        byte_compile Dir["*.el"]
        (share/"emacs/site-lisp/auto-complete/ac-php").install Dir["*.el"], Dir["*.elc"]
      end
    end

    if build.with? "slime"
      resource("slime").stage do
        byte_compile "ac-slime.el"
        (share/"emacs/site-lisp/auto-complete/ac-slime").install "ac-slime.el", "ac-slime.elc"
      end
    end

    ert_run_tests "tests/run-test.el"
    byte_compile "auto-complete.el", "auto-complete-config.el"
    (share/"emacs/site-lisp/auto-complete").install Dir["*.el"],
                                                    Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/auto-complete")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/popup"].opt_share}/emacs/site-lisp/popup")

      (load "auto-complete")
      (print ac-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

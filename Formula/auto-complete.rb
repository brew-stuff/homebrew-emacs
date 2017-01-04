require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AutoComplete < EmacsFormula
  desc "Autocompletion extension for Emacs"
  homepage "https://github.com/auto-complete/auto-complete"
  url "https://github.com/auto-complete/auto-complete/archive/v1.5.1.tar.gz"
  sha256 "1bfb4351c3e49681a875dab937c25b6b38e4bf8a8cd64bcba1954300242578cb"
  head "https://github.com/auto-complete/auto-complete.git"

  option "with-etags", "Install ac-etags"
  option "with-haskell", "Install ac-haskell-process"
  option "with-helm", "Use helm for selecting completion candidates"
  option "with-html", "Install ac-html"
  option "with-ispell", "Install ac-ispell"
  option "with-php", "Install ac-php"
  option "with-slime", "Install ac-slime"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/popup"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  depends_on "homebrew/emacs/haskell-mode" if build.with? "haskell"
  depends_on "homebrew/emacs/helm" if build.with? "helm"
  depends_on "homebrew/emacs/slime" if build.with? "slime"

  if build.with? "html"
    depends_on "homebrew/emacs/dash-emacs"
    depends_on "homebrew/emacs/web-completion-data"
  end

  if build.with? "php"
    depends_on "homebrew/emacs/f-emacs"
    depends_on "homebrew/emacs/popup"
    depends_on "homebrew/emacs/s-emacs"
    depends_on "homebrew/emacs/xcscope"
    depends_on "homebrew/emacs/yasnippet"
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

  resource "php" do
    url "https://github.com/xcwen/ac-php/archive/1.7.5.tar.gz"
    sha256 "1730bfc2292c707c105f4c8abee5b6c76b178fa2e649bde5ad39f35bf194d538"
  end

  resource "slime" do
    url "https://github.com/purcell/ac-slime/archive/0.8.tar.gz"
    sha256 "c33d8098708899f103d4b50daf45f3fb6d8e8ae57a912ece5c682da86afe0540"
  end

  def install
    if build.with? "etags"
      resource("etags").stage do
        byte_compile "ac-etags.el"
        elisp.install "ac-etags.el", "ac-etags.elc"
      end
    end

    if build.with? "haskell"
      resource("haskell").stage do
        byte_compile "ac-haskell-process.el"
        elisp.install "ac-haskell-process.el", "ac-haskell-process.elc"
      end
    end

    if build.with? "helm"
      resource("helm").stage do
        byte_compile "ac-helm.el"
        elisp.install "ac-helm.el", "ac-helm.elc"
      end
    end

    if build.with? "html"
      resource("html").stage do
        ert_run_tests "test/run-test.el"
        byte_compile Dir["*.el"]
        elisp.install Dir["*.el"], Dir["*.elc"]
      end
    end

    if build.with? "ispell"
      resource("ispell").stage do
        byte_compile "ac-ispell.el"
        elisp.install "ac-ispell.el", "ac-ispell.elc"
      end
    end

    if build.with? "php"
      resource("php").stage do
        ert_run_tests "tests/ac-php-test.el"
        byte_compile (Dir["*.el"] - ["company-php.el"])
        elisp.install [(Dir["*.el"] - ["company-php.el"]),
                       Dir["*.elc"], Dir["*.json"], "phpctags"].flatten
      end
    end

    if build.with? "slime"
      resource("slime").stage do
        byte_compile "ac-slime.el"
        elisp.install "ac-slime.el", "ac-slime.elc"
      end
    end

    ert_run_tests "tests/run-test.el"
    byte_compile "auto-complete.el", "auto-complete-config.el"
    elisp.install Dir["*.el"], Dir["*.elc"]
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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AutoComplete < EmacsFormula
  desc "Autocompletion extension for Emacs"
  homepage "https://github.com/auto-complete/auto-complete"
  url "https://github.com/auto-complete/auto-complete/archive/v1.5.0.tar.gz"
  sha256 "a960848fcb94f438c6795070b3125c1a039bf11cc058dbd60e8668adb3cebe4c"
  head "https://github.com/auto-complete/auto-complete.git"

  option "with-c-headers", "Install ac-c-headers"
  option "with-etags", "Install ac-etags"
  option "with-haskell", "Install ac-haskell-process"
  option "with-helm", "Use helm for selecting completion candidates"
  option "with-html", "Install ac-html"
  option "with-ispell", "Install ac-ispell"
  option "with-js2", "Install ac-js2"
  option "with-php", "Install ac-php"
  option "with-slime", "Install ac-slime"

  depends_on :emacs => "24.1"
  depends_on "cask"
  depends_on "homebrew/emacs/popup"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  depends_on "homebrew/emacs/haskell-mode" if build.with? "haskell"
  depends_on "homebrew/emacs/helm" if build.with? "helm"
  depends_on "homebrew/emacs/slime" if build.with? "slime"

  if build.with? "html"
    depends_on "homebrew/emacs/dash"
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
    url "https://github.com/xcwen/ac-php/archive/1.4.2.tar.gz"
    sha256 "6f805a71911837dea1f13d45830f81ffab8625ae56156265761808c1d7bd5d18"
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
        # tests open a browser window
        # ert_run_tests "ac-js2-tests.el"
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

    system "make", "test", "CASK=#{Formula["cask"].bin}/cask"
    system "make", "byte-compile", "CASK=#{Formula["cask"].bin}/cask"
    (share/"emacs/site-lisp/auto-complete").install Dir["*.el"],
                                                    Dir["*.elc"]
  end

  def caveats
    s = <<-EOS.undent
      Add the following to your init file:

      (require 'auto-complete)
    EOS
    if build.with? "c-headers"
      s += <<-EOS.undent

      (require 'ac-c-headers)
      (add-hook 'c-mode-hook
                (lambda ()
                  (add-to-list 'ac-sources 'ac-source-c-headers)
                  (add-to-list 'ac-sources 'ac-source-c-header-symbols t)))
    EOS
    end
    if build.with? "etags"
      s += <<-EOS.undent

      (require 'ac-etags)
      (ac-etags-setup)
    EOS
    end
    if build.with? "haskell"
      s += <<-EOS.undent

      (require 'ac-haskell-process)
      (add-hook 'interactive-haskell-mode-hook 'ac-haskell-process-setup)
      (add-hook 'haskell-interactive-mode-hook 'ac-haskell-process-setup)
      (eval-after-load "auto-complete"
        '(add-to-list 'ac-modes 'haskell-interactive-mode))
    EOS
    end
    if build.with? "helm"
      s += <<-EOS.undent

      (require 'ac-helm)
      (global-set-key (kbd "C-:") 'ac-complete-with-helm)
      (define-key ac-complete-mode-map (kbd "C-:") 'ac-complete-with-helm)
    EOS
    end
    if build.with? "html"
      s += <<-EOS.undent

      (require 'ac-html)
      (add-hook 'html-mode-hook 'ac-html-enable)
    EOS
    end
    if build.with? "ispell"
      s += <<-EOS.undent

      (require 'ac-ispell)
      (ac-ispell-setup)
    EOS
    end
    if build.with? "js2"
      s += <<-EOS.undent

      (require 'ac-js2)
      (add-hook 'js2-mode-hook 'ac-js2-mode)
    EOS
    end
    if build.with? "php"
      s += <<-EOS.undent

      (require 'ac-php)
      (add-hook 'php-mode-hook
                  '(lambda ()
                     (auto-complete-mode t)
                     (require 'ac-php)
                     (setq ac-php-use-cscope-flag  t ) ;; enable cscope
                     (setq ac-sources  '(ac-source-php ) )
                     (yas-global-mode 1)
                     (define-key php-mode-map  (kbd "C-]") 'ac-php-find-symbol-at-point)   ;goto define
                     (define-key php-mode-map  (kbd "C-t") 'ac-php-location-stack-back   ) ;go back
                     ))
    EOS
    end
    if build.with? "slime"
      s += <<-EOS.undent

      (require 'ac-slime)
      (add-hook 'slime-mode-hook 'set-up-slime-ac)
      (add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
      (eval-after-load "auto-complete"
        '(add-to-list 'ac-modes 'slime-repl-mode))
    EOS
    end
    s
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Flycheck < EmacsFormula
  desc "On-the-fly syntax checking extension"
  homepage "http://www.flycheck.org/"
  url "https://github.com/flycheck/flycheck/archive/0.25.1.tar.gz"
  sha256 "90f0c51a65966291577a1714f9d230de4b56969849add22cf580955351867ee0"
  head "https://github.com/flycheck/flycheck.git"

  option "with-cask", "Build with Cask support"
  option "with-color-mode-line", "Include minor mode for coloring the mode-line"
  option "with-haskell", "Build with improved Haskell support"
  option "with-package", "Include checker for package metadata"
  option "with-pos-tip", "Use pos-tip for tooltip display"

  depends_on :emacs => "24.3"
  depends_on "cask"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/let-alist"
  depends_on "homebrew/emacs/pkg-info"
  depends_on "homebrew/emacs/seq"
  depends_on "homebrew/emacs/haskell-mode" if build.with? "haskell"
  depends_on "homebrew/emacs/pos-tip" if build.with? "pos-tip"

  resource "cask" do
    url "https://github.com/flycheck/flycheck-cask/archive/0.3.tar.gz"
    sha256 "920b55028ad62b7921c4eaa3a1714db0900aff1094a4b43fb6aa866e8c9a0184"
  end

  resource "color-mode-line" do
    url "https://github.com/flycheck/flycheck-color-mode-line/archive/0.3.tar.gz"
    sha256 "b71825f79569960b23c81d9e3ad0c3fb581eaccb84a52fa0cca48d9fa5284e4c"
  end

  resource "haskell" do
    url "https://github.com/flycheck/flycheck-haskell/archive/0.7.2.tar.gz"
    sha256 "c1e7766a6b476d5ee11fdade871017487160e56cd226d7308a090d322ce2e68a"
  end

  resource "package" do
    url "https://github.com/purcell/flycheck-package/archive/0.8.tar.gz"
    sha256 "86bcccb66b68ea31707429c0da59fe616a9ecc93a8b9e782055758a4888ca030"
  end

  resource "pos-tip" do
    url "https://github.com/flycheck/flycheck-pos-tip/archive/0.1.tar.gz"
    sha256 "6a29678399239f42b9038238ededff2e8d407824878ead6af0770143ec8a8ec4"
  end

  def install
    resources.each do |r|
      next if build.without? r.name
      r.stage do
        byte_compile "flycheck-#{r.name}.el"
        elisp.install "flycheck-#{r.name}.el", "flycheck-#{r.name}.elc"
      end
    end

    system "make", "compile", "CASK=#{Formula["cask"].bin}/cask"
    elisp.install Dir["*.el"], Dir["*.elc"]
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/pkg-info"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/epl"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/seq"].opt_elisp}")
      (load "flycheck")
      (load "pkg-info")
      (print (flycheck-version))
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

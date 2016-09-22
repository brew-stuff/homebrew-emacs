require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Flycheck < EmacsFormula
  desc "On-the-fly syntax checking extension"
  homepage "http://www.flycheck.org/"
  url "https://github.com/flycheck/flycheck/releases/download/29/flycheck-29.tar"
  sha256 "d3bee0455327c86c6d756ac0ba7b47641f8092ab2f248b6039bd7c9e6f275eff"
  head "https://github.com/flycheck/flycheck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8c79ce7a1208e51677f75b4413e38da38b2480d6e2cc5b3358b2f9f4ab85d6e" => :sierra
    sha256 "b8c79ce7a1208e51677f75b4413e38da38b2480d6e2cc5b3358b2f9f4ab85d6e" => :el_capitan
    sha256 "b8c79ce7a1208e51677f75b4413e38da38b2480d6e2cc5b3358b2f9f4ab85d6e" => :yosemite
  end

  option "with-cask", "Build with Cask support"
  option "with-color-mode-line", "Include minor mode for coloring the mode-line"
  option "with-haskell", "Build with improved Haskell support"
  option "with-package", "Include checker for package metadata"
  option "with-pos-tip", "Use pos-tip for tooltip display"

  depends_on emacs: "24.3"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/let-alist"
  depends_on "homebrew/emacs/pkg-info"
  depends_on "homebrew/emacs/seq" if Emacs.version < Version.create("25")
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
    url "https://github.com/flycheck/flycheck-haskell/archive/0.8.tar.gz"
    sha256 "05734cf5f2716c55c718c2bd66e36690795235d65e9774efb7bfee2849814603"
  end

  resource "package" do
    url "https://github.com/purcell/flycheck-package/archive/0.9.tar.gz"
    sha256 "90499e255116b5a4df8dd32f4221f63c77027f754b9fe9a3b15be7c696b0549c"
  end

  resource "pos-tip" do
    url "https://github.com/flycheck/flycheck-pos-tip/archive/hotfix-0.25.1.tar.gz"
    sha256 "fb5b66ae1ecf3aca87fd5e0de88b98301d6fa3f6ec4562677d209349265dd553"
    version "0.1-hotfix"
  end

  def install
    resources.each do |r|
      next if build.without? r.name
      r.stage do
        byte_compile "flycheck-#{r.name}.el"
        elisp.install "flycheck-#{r.name}.el", "flycheck-#{r.name}.elc"
      end
    end

    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
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

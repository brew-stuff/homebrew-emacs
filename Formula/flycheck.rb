require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Flycheck < EmacsFormula
  desc "On-the-fly syntax checking extension"
  homepage "http://www.flycheck.org/"
  url "https://github.com/flycheck/flycheck/releases/download/30/flycheck-30.tar"
  sha256 "c7ef2e0195bd32af96180dff4602a86af2ed147f9a1735b51d1f11a9b19abfe7"
  head "https://github.com/flycheck/flycheck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d82dee34882058d5f9847c1eca06397e5dd4da18648a824fccf2c528c9d0cc8" => :sierra
    sha256 "4d82dee34882058d5f9847c1eca06397e5dd4da18648a824fccf2c528c9d0cc8" => :el_capitan
    sha256 "4d82dee34882058d5f9847c1eca06397e5dd4da18648a824fccf2c528c9d0cc8" => :yosemite
  end

  option "with-cask", "Build with Cask support"
  option "with-color-mode-line", "Include minor mode for coloring the mode-line"
  option "with-haskell", "Build with improved Haskell support"
  option "with-package", "Include checker for package metadata"
  option "with-pos-tip", "Use pos-tip for tooltip display"

  depends_on :emacs => "24.3"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/let-alist"
  depends_on "homebrew/emacs/pkg-info"
  depends_on "homebrew/emacs/seq" if Emacs.version < Version.create("25")
  depends_on "homebrew/emacs/haskell-mode" if build.with? "haskell"
  depends_on "homebrew/emacs/pos-tip" if build.with? "pos-tip"

  resource "cask" do
    url "https://github.com/flycheck/flycheck-cask/archive/0.4.tar.gz"
    sha256 "0446ae1e69a2827ac0cd7dd45f971853f3bf425c812bdf79965125a00c943aaf"
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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Flycheck < EmacsFormula
  desc "On-the-fly syntax checking extension"
  homepage "http://www.flycheck.org/"
  url "https://github.com/flycheck/flycheck/releases/download/31/flycheck-31.tar"
  sha256 "80086d3970fa3327a284ebdf69e7c842ae0a0c2b6c28e6b2f7ec5413ace23607"
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
  depends_on "dunn/emacs/dash-emacs"
  depends_on "dunn/emacs/let-alist"
  depends_on "dunn/emacs/pkg-info"
  depends_on "dunn/emacs/seq" if Emacs.version < Version.create("25")
  depends_on "dunn/emacs/haskell-mode" if build.with? "haskell"
  depends_on "dunn/emacs/pos-tip" if build.with? "pos-tip"

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
    url "https://github.com/flycheck/flycheck-pos-tip/archive/0.3.tar.gz"
    sha256 "adc8bf677e0c917b2f85d248b80ff9b7d90d93fdf7f605b78bcc7369a516fa2d"
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
      (add-to-list 'load-path "#{Formula["dunn/emacs/pkg-info"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/epl"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/seq"].opt_elisp}")
      (load "flycheck")
      (load "pkg-info")
      (print (flycheck-version))
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

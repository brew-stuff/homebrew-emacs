require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Smartparens < EmacsFormula
  desc "Minor mode for Emacs that deals with parens pairs"
  homepage "https://github.com/Fuco1/smartparens"
  url "https://github.com/Fuco1/smartparens/archive/1.9.0.tar.gz"
  sha256 "9834d1b0d93b0a5b308e56213f81c18cf0d9483163d6822d453be9004f2e0688"
  head "https://github.com/Fuco1/smartparens.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b5afc186540b656d37b41575a81b8f9b186d448b1115481cf7810a715eea642" => :sierra
    sha256 "5b5afc186540b656d37b41575a81b8f9b186d448b1115481cf7810a715eea642" => :el_capitan
    sha256 "5b5afc186540b656d37b41575a81b8f9b186d448b1115481cf7810a715eea642" => :yosemite
  end

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")
  depends_on "homebrew/emacs/dash-emacs"

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
    doc.install "smartparens.org"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (load "smartparens")
      (turn-on-smartparens-mode)
      (turn-off-smartparens-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

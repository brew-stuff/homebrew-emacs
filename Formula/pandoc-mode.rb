require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PandocMode < EmacsFormula
  desc "Emacs minor mode for interacting with pandoc"
  homepage "https://joostkremers.github.io/pandoc-mode/"
  url "https://github.com/joostkremers/pandoc-mode/archive/2.20.tar.gz"
  sha256 "92d24bcdf0ec0b8cba4b4c9aed90d521a25622c9520f4b7aa27366c60c630a13"
  head "https://github.com/joostkremers/pandoc-mode.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7d4e0feab9192e3ec657e23d94b2d6b776664bc310103795f02d106ce008abe" => :sierra
    sha256 "f7d4e0feab9192e3ec657e23d94b2d6b776664bc310103795f02d106ce008abe" => :el_capitan
    sha256 "f7d4e0feab9192e3ec657e23d94b2d6b776664bc310103795f02d106ce008abe" => :yosemite
  end

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/hydra-emacs"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
    info.install "pandoc-mode.info"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{Formula["homebrew/emacs/cl-lib"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/hydra-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{elisp}")
      (load "pandoc-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PandocMode < EmacsFormula
  desc "Emacs minor mode for interacting with pandoc"
  homepage "https://joostkremers.github.io/pandoc-mode/"
  url "https://github.com/joostkremers/pandoc-mode/archive/2.21.tar.gz"
  sha256 "ef735249f8140de9ceac967d42c412a57d0444e9b6183f076f87f9c4a8293218"
  head "https://github.com/joostkremers/pandoc-mode.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f42c042b239ec443937cb21b2846356668b2c9975fe27b106e991fe3331e55a" => :sierra
    sha256 "9f42c042b239ec443937cb21b2846356668b2c9975fe27b106e991fe3331e55a" => :el_capitan
    sha256 "9f42c042b239ec443937cb21b2846356668b2c9975fe27b106e991fe3331e55a" => :yosemite
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

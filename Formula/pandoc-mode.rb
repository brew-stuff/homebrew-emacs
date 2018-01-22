require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PandocMode < EmacsFormula
  desc "Emacs minor mode for interacting with pandoc"
  homepage "https://joostkremers.github.io/pandoc-mode/"
  url "https://github.com/joostkremers/pandoc-mode/archive/2.22.tar.gz"
  sha256 "0f47e8a1e486f19a0a4b5e6f537a223ce5a468eb32f4d885bae8f46f9046e8ea"
  head "https://github.com/joostkremers/pandoc-mode.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6661b3e1a1040338f88d26c2c4cecd5787873b3c9f6cd1c30fbd585592b2bc83" => :sierra
    sha256 "6661b3e1a1040338f88d26c2c4cecd5787873b3c9f6cd1c30fbd585592b2bc83" => :el_capitan
    sha256 "6661b3e1a1040338f88d26c2c4cecd5787873b3c9f6cd1c30fbd585592b2bc83" => :yosemite
  end

  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/dash-emacs"
  depends_on "dunn/emacs/hydra-emacs"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
    info.install "pandoc-mode.info"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{Formula["dunn/emacs/cl-lib"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/hydra-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{elisp}")
      (load "pandoc-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

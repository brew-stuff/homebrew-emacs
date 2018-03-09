require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AceWindow < EmacsFormula
  desc "Faster window switching in Emacs"
  homepage "https://github.com/abo-abo/ace-window"
  url "https://github.com/abo-abo/ace-window/archive/0.9.0.tar.gz"
  sha256 "f616898826457431a235294165866875a72a2a3514376adafa84d656a87b5adc"
  head "https://github.com/abo-abo/ace-window.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb3d6af5535dcdd691e8c2d49ea7c7bfa702be2a0f2636f490c00ae074d40f59" => :el_capitan
    sha256 "203e1f373ffe7fde6c54f7c7d2bac0ea54c8155426ea244ff7773c71843eba5f" => :yosemite
    sha256 "203e1f373ffe7fde6c54f7c7d2bac0ea54c8155426ea244ff7773c71843eba5f" => :mavericks
  end

  depends_on EmacsRequirement
  depends_on "dunn/emacs/avy"

  def install
    byte_compile "ace-window.el"
    elisp.install "ace-window.el", "ace-window.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/avy"].opt_elisp}")
      (load "ace-window")
      (aw-window-list)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WhichKey < EmacsFormula
  desc "Emacs package for displaying available keybindings"
  homepage "https://github.com/justbur/emacs-which-key"
  url "https://github.com/justbur/emacs-which-key/archive/v1.2.1.tar.gz"
  sha256 "787a456e7377c9b1e7c6df8fd32403971d649c801d79e71e57a638d04edf6abd"
  head "https://github.com/justbur/emacs-which-key.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "16ac1315b3585c0d1c96a5dab1bd35fcf22acd3df6b87b294dc28e56faf286e1" => :sierra
    sha256 "16ac1315b3585c0d1c96a5dab1bd35fcf22acd3df6b87b294dc28e56faf286e1" => :el_capitan
    sha256 "16ac1315b3585c0d1c96a5dab1bd35fcf22acd3df6b87b294dc28e56faf286e1" => :yosemite
  end

  depends_on :emacs => "24.3"

  def install
    ert_run_tests "which-key-tests.el"
    byte_compile "which-key.el"
    elisp.install "which-key.el", "which-key.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "which-key")
      (which-key-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

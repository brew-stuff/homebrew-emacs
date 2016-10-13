require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AggressiveIndent < EmacsFormula
  desc "Emacs minor mode to keep code always indented"
  homepage "https://github.com/Malabarba/aggressive-indent-mode"
  url "https://elpa.gnu.org/packages/aggressive-indent-1.8.3.el"
  sha256 "d272e4b93ef20cb21fb1ba1a3c88348af39bd2b5b1f397ef551c74502863df4a"
  head "https://github.com/Malabarba/aggressive-indent-mode.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba490be18e32f1529179972b5f03bd729fd527df1c780c4681eaee61e64edd09" => :sierra
    sha256 "ba490be18e32f1529179972b5f03bd729fd527df1c780c4681eaee61e64edd09" => :el_capitan
    sha256 "ba490be18e32f1529179972b5f03bd729fd527df1c780c4681eaee61e64edd09" => :yosemite
  end

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    mv "aggressive-indent-#{version}.el", "aggressive-indent.el" if build.stable?
    byte_compile "aggressive-indent.el"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/aggressive-indent")
      (load "aggressive-indent")
      (global-aggressive-indent-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

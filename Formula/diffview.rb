require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Diffview < EmacsFormula
  desc "View diffs side-by-side in Emacs"
  homepage "https://github.com/mgalgs/diffview-mode"
  url "https://elpa.gnu.org/packages/diffview-1.0.el"
  sha256 "91b3c9cfa03230fb78555b3d714c3c0ffc8984c7bbb733954dbf47f9eaaf6dbe"
  head "https://github.com/mgalgs/diffview-mode.git"

  depends_on :emacs

  def install
    mv "diffview-#{version}.el", "diffview.el" if build.stable?
    byte_compile "diffview.el"
    elisp.install "diffview.el", "diffview.elc"
    prefix.install "screenshots" if build.head?
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "diffview")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

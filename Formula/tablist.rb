require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Tablist < EmacsFormula
  desc "Extended tabulated-list-mode for Emacs"
  homepage "https://github.com/politza/tablist"
  url "https://github.com/politza/tablist/archive/v0.70.tar.gz"
  sha256 "2cfd4e8060e045a5fb49f56ba1d21b09d8f149c809500b6df8bc86ea8f36ed9c"
  head "https://github.com/politza/tablist.git"

  depends_on EmacsRequirement => "24.3"

  def install
    byte_compile "tablist.el", "tablist-filter.el"
    elisp.install "tablist.el", "tablist.elc",
                  "tablist-filter.el", "tablist-filter.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "tablist")
      (tablist-quit)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

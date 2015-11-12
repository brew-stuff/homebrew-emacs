require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Tablist < EmacsFormula
  desc "Extended tabulated-list-mode for Emacs"
  homepage "https://github.com/politza/tablist"
  head "https://github.com/politza/tablist.git"

  depends_on :emacs => "24.3"

  def install
    byte_compile "tablist.el", "tablist-filter.el"
    elisp.install "tablist.el", "tablist.elc",
                  "tablist-filter.el", "tablist-filter.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "tablist")
      (tablist-quit)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../Homebrew/emacs_formula", __dir__)

class CsvMode < EmacsFormula
  desc "Emacs major mode for editing delimited-field files"
  homepage "https://elpa.gnu.org/packages/csv-mode.html"
  url "https://elpa.gnu.org/packages/csv-mode-1.7.el"
  sha256 "e69fb8420d89cbfcafffe02fbf15cc9524e13e3300766d208aa5c0c1c18d8b64"

  depends_on EmacsRequirement => "23.1"

  def install
    mv "csv-mode-#{version}.el", "csv-mode.el"

    byte_compile "csv-mode.el"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/csv-mode")
      (load "csv-mode")
      (csv-toggle-descending)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

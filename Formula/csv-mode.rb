require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CsvMode < EmacsFormula
  desc "Emacs major mode for editing delimited-field files"
  homepage "https://elpa.gnu.org/packages/csv-mode.html"
  url "https://elpa.gnu.org/packages/csv-mode-1.6.el"
  sha256 "caac29cb7a1abe9da08bd6be32155acbd1bb3c8e721a777529d95e1f94c506ed"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/csv-mode/csv-mode.el"

  depends_on EmacsRequirement

  def install
    mv "csv-mode-#{version}.el", "csv-mode.el" if build.stable?

    byte_compile "csv-mode.el"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/csv-mode")
      (load "csv-mode")
      (csv-toggle-descending)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

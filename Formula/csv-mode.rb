require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CsvMode < EmacsFormula
  desc "Emacs major mode for editing delimited-field files"
  homepage "https://sites.google.com/site/fjwcentaur/emacs"
  url "http://elpa.gnu.org/packages/csv-mode-1.5.el"
  sha256 "ac872ed07b18869165a2848c43b06b36fa73dce5f199ac79123a55b3f232acb6"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/csv-mode/csv-mode.el"

  depends_on :emacs

  def install
    mv "csv-mode-#{version}.el", "csv-mode.el" if build.stable?

    byte_compile "csv-mode.el"
    (share/"emacs/site-lisp/csv-mode").install Dir["*.el"],
                                               Dir["*.elc"]
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

      (add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
      (autoload 'csv-mode "csv-mode"
        "Major mode for editing comma-separated value files." t)
    EOS
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

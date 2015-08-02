require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CompanyStatistics < EmacsFormula
  desc "Sort Emacs completions by selection history"
  homepage "https://github.com/company-mode/company-statistics"
  url "https://github.com/company-mode/company-statistics/archive/0.2.1.tar.gz"
  sha256 "fca0b0a78a90c337cd139ee844afa9369ce46be5375b2284ee1d5b350e2cc201"
  head "https://github.com/company-mode/company-statistics.git"

  depends_on :emacs => "24.3"
  depends_on "dunn/emacs/company-mode"

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/company-statistics").install Dir["*.el"],
                                                         Dir["*.elc"]
    doc.install "README.org"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'company-statistics)
    (company-statistics-mode)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/company-statistics")
      (add-to-list 'load-path "#{Formula["dunn/emacs/company-mode"].share}/emacs/site-lisp/company")
      (load "company-statistics")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

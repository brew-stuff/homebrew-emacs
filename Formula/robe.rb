require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Robe < EmacsFormula
  desc "Navigation, documentation lookup and completion for Ruby"
  homepage "https://github.com/dgutov/robe"
  url "https://github.com/dgutov/robe/archive/0.8.1.tar.gz"
  sha256 "790d201cc8aa7c95aaf9ca10b322c3c8944ffebd9e4045c047487297922fe4ee"
  head "https://github.com/dgutov/robe.git"

  depends_on EmacsRequirement => "24.4"
  depends_on :ruby => "1.9"
  depends_on "dunn/emacs/inf-ruby"

  def install
    ert_run_tests "ert/core-tests.el"

    byte_compile "robe.el", "ac-robe.el", "company-robe.el"
    elisp.install "robe.el", "ac-robe.el", "company-robe.el",
                  "robe.elc", "ac-robe.elc", "company-robe.elc",
                  "lib"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["inf-ruby"].opt_elisp}")
      (load "robe")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class F < EmacsFormula
  desc "Emacs filesystem API"
  homepage "https://github.com/rejeep/f.el"
  url "https://github.com/rejeep/f.el/archive/v0.17.3.tar.gz"
  sha256 "6d39b521dccdfa03e09daf99a5e11d8fde1854517733d69cf1b6a9313fe6ef3e"
  head "https://github.com/rejeep/f.el.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/s"

  def install
    # make test/compile requires emacs-parallel
    byte_compile "f.el"
    elisp.install "f.el", "f.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/s"].opt_elisp}")
      (load "f")
      (print (f-this-file))
    EOS
    assert_equal "\"#{testpath}/test.el\"",
                 shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

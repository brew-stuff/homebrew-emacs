require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class HomebrewMode < EmacsFormula
  desc "Emacs minor mode for editing Homebrew formulae"
  homepage "https://github.com/dunn/homebrew-mode"
  url "https://github.com/dunn/homebrew-mode/archive/1.3.6.tar.gz"
  sha256 "f362f572b3fd0de4f41783d9416f80068fe78589c320b58881ac455dd62fea05"
  head "https://github.com/dunn/homebrew-mode.git"

  depends_on :emacs => "24.4"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/inf-ruby"

  def install
    system "make", "tests",
           "inf_ruby=#{Formula["homebrew/emacs/inf-ruby"].opt_elisp}",
           "dash=#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}"

    system "make", "install", "prefix=#{prefix}",
           "inf_ruby=#{Formula["homebrew/emacs/inf-ruby"].opt_elisp}",
           "dash=#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/homebrew-mode")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/inf-ruby"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")

      (load "homebrew-mode")
      (print homebrew-mode-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

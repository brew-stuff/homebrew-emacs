require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class HomebrewMode < EmacsFormula
  desc "Emacs minor mode for editing Homebrew formulae"
  homepage "https://github.com/dunn/homebrew-mode"
  url "https://github.com/dunn/homebrew-mode/archive/1.3.2.tar.gz"
  sha256 "2110552ed8c7f924cf00dc2985c1e242aceb1b385d5ceeb9267a1652a8e20ed0"
  head "https://github.com/dunn/homebrew-mode.git"

  depends_on :emacs => "24.4"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/inf-ruby"

  def install
    system "make", "test",
           "inf_ruby=#{Formula["homebrew/emacs/inf-ruby"].opt_share}/emacs/site-lisp/inf-ruby",
           "dash=#{Formula["homebrew/emacs/dash-emacs"].opt_share}/emacs/site-lisp/dash"

    system "make", "install", "prefix=#{prefix}",
           "inf_ruby=#{Formula["homebrew/emacs/inf-ruby"].opt_share}/emacs/site-lisp/inf-ruby",
           "dash=#{Formula["homebrew/emacs/dash-emacs"].opt_share}/emacs/site-lisp/dash"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/homebrew-mode")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/inf-ruby"].opt_share}/emacs/site-lisp/inf-ruby")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_share}/emacs/site-lisp/dash")

      (load "homebrew-mode")
      (print homebrew-mode-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

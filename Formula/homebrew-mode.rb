require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class HomebrewMode < EmacsFormula
  desc "Emacs minor mode for editing Homebrew formulae"
  homepage "https://github.com/dunn/homebrew-mode"
  url "https://github.com/dunn/homebrew-mode/archive/1.3.5.tar.gz"
  sha256 "ffac1f32b1780d0cfada9d57f33fe895ae46150962f7e6c2e32b69ff94fa9fc2"
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

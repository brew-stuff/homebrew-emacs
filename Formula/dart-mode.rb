require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DartMode < EmacsFormula
  desc "Major mode for editing Dart code"
  homepage "https://github.com/nex3/dart-mode"
  url "https://github.com/nex3/dart-mode.git",
      :tag => "0.15", :revision => "e6635b390235cf16a8081763768cf925ca2d9133"
  head "https://github.com/nex3/dart-mode.git"

  depends_on :emacs => "25.1"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/flycheck"

  def install
    byte_compile "dart-mode.el"
    elisp.install "dart-mode.el", "dart-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/flycheck"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/seq"].opt_elisp}")
      (load "dart-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

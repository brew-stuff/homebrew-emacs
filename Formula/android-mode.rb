require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AndroidMode < EmacsFormula
  desc "Emacs minor mode for Android application development"
  homepage "https://github.com/remvee/android-mode"
  url "https://github.com/remvee/android-mode/archive/0.5.0.tar.gz"
  sha256 "39d0acfe3cd23d3234012f213548411ce922f68f1e5edf7a66b8e682bf5edf45"
  head "https://github.com/remvee/android-mode.git"

  bottle :disable

  depends_on :emacs => "22.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile "android-mode.el"
    elisp.install "android-mode.el", "android-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/cl-lib"].opt_elisp}")
      (load "android-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

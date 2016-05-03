require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AndroidMode < EmacsFormula
  desc "Emacs minor mode for Android application development"
  homepage "https://github.com/remvee/android-mode"
  url "https://github.com/remvee/android-mode/archive/0.4.0.tar.gz"
  sha256 "8b88d08198e5b0e0a7bd9fb0ff3d04213a84f5f9573c20a5d8a4797542b23e97"
  head "https://github.com/remvee/android-mode.git"

  depends_on :emacs => "22.1"

  def install
    byte_compile "android-mode.el"
    elisp.install "android-mode.el", "android-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "android-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

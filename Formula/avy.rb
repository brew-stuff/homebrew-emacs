require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Avy < EmacsFormula
  desc "Emacs library for navigating text via trees"
  homepage "https://github.com/abo-abo/avy"
  url "https://github.com/abo-abo/avy/archive/0.4.0.tar.gz"
  sha256 "269d1a0710f86c3fd82a7099f5b9f359b45d7dd36b0ab7e4afbe082842c1b9f1"
  head "https://github.com/abo-abo/avy.git"

  depends_on :emacs => "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    system "make", "compile"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "avy")
      (avy-setup-default)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

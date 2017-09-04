require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TinyEmacs < EmacsFormula
  desc "Emacs package for generating linear ranges"
  homepage "https://github.com/abo-abo/tiny"
  url "https://elpa.gnu.org/packages/tiny-0.2.1.tar"
  sha256 "5b349e66c0e54b81f66976fd641cf77f38528a160cf452944ca4a8f5901a27b3"
  head "https://github.com/abo-abo/tiny.git"

  depends_on :emacs
  depends_on "dunn/emacs/undercover" => :build

  def install
    ert_run_tests "tiny-test.el"
    system "make", "compile"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "tiny")
      (print (tiny-tokenize "+x2"))
    EOS
    assert_equal "\"(+ x 2)\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

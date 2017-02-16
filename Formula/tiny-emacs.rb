require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TinyEmacs < EmacsFormula
  desc "Emacs package for generating linear ranges"
  homepage "https://github.com/abo-abo/tiny"
  head "https://github.com/abo-abo/tiny.git"

  stable do
    url "https://elpa.gnu.org/packages/tiny-0.1.1.tar"
    sha256 "c77a8fc0ee7ccb7cb0a1367031975afd202d8e54ae7620f929c4365cce400fda"

    patch do
      url "https://github.com/abo-abo/tiny/commit/d775201a6e14aae03dda032132aa288ca93bddc4.diff"
      sha256 "ea486e83a803f2c3e0b2eee1fb809e9584b2b8e09a400cc1f6e0ef6efd043ac5"
    end
  end

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

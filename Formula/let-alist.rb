require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class LetAlist < EmacsFormula
  desc "Easily let-bind values of an assoc-list by their names"
  homepage "https://elpa.gnu.org/packages/let-alist.html"
  url "https://elpa.gnu.org/packages/let-alist-1.0.5.el"
  sha256 "fc6b2900e461eb02c0be0365daaa130d3daf43a095ce994e0d8a8212ad4ceb64"

  depends_on EmacsRequirement => "24.1"

  bottle :disable

  def install
    mv "let-alist-#{version}.el", "let-alist.el"
    byte_compile "let-alist.el"
    elisp.install "let-alist.el", "let-alist.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "let-alist")
      (print
        (let ((alist '((cat . meow)
                       (dog . woof))))
          (let-alist alist
            .cat)))
    EOS
    assert_equal "meow", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

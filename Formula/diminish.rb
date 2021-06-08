require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Diminish < EmacsFormula
  desc "Hide modeline display of Emacs minor modes"
  homepage "https://github.com/myrjola/diminish.el"
  url "https://github.com/myrjola/diminish.el/archive/v0.45.tar.gz"
  sha256 "49ce6cb24d40bde0f3e82a30adbc19b322fd3e56d53208c0cad9b1b275126644"
  head "https://github.com/myrjola/diminish.el.git"

  depends_on EmacsRequirement

  def install
    byte_compile "diminish.el"
    elisp.install "diminish.el", "diminish.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "diminish")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs --quick --batch --load #{testpath}/test.el").strip
  end
end

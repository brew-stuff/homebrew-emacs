require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class UsePackage < EmacsFormula
  desc "A use-package declaration for simplifying your .emacs"
  homepage "https://github.com/jwiegley/use-package"
  url "https://github.com/jwiegley/use-package/archive/20140601.tar.gz"
  version "20140601"
  sha256 "70dccc5d1977cf659b557bba49a6bd886b1e44325f63cef8dd69ddebb7e11823"
  head "https://github.com/jwiegley/use-package.git"

  depends_on :emacs
  depends_on "homebrew/emacs/diminish"
  depends_on "homebrew/emacs/bind-key"

  def install
    byte_compile "use-package.el"
    (share/"emacs/site-lisp/use-package").install "use-package.el", "use-package.elc"
    generate_autoloads
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{Formula["homebrew/emacs/bind-key"].share}/emacs/site-lisp/bind-key")
      (add-to-list 'load-path "#{share}/emacs/site-lisp/use-package")
      (load "use-package")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs --quick --batch --load #{testpath}/test.el").strip
  end
end

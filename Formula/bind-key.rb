require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class BindKey < EmacsFormula
  desc "A simple way to manage personal keybindings"
  homepage "https://github.com/jwiegley/use-package/blob/master/bind-key.el"
  url "https://github.com/jwiegley/use-package/archive/20140601.tar.gz"
  version "20140601"
  sha256 "70dccc5d1977cf659b557bba49a6bd886b1e44325f63cef8dd69ddebb7e11823"
  head "https://github.com/jwiegley/use-package.git"


  def install
    byte_compile "bind-key.el"
    (share/"emacs/site-lisp/bind-key").install "bind-key.el", "bind-key.elc"
    generate_autoloads if build.head?
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/bind-key")
      (load "bind-key")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs --quick --batch --load #{testpath}/test.el").strip
  end
end

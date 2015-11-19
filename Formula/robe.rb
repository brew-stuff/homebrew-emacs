require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Robe < EmacsFormula
  desc "Navigation, documentation lookup and completion for Ruby"
  homepage "https://github.com/dgutov/robe"
  url "https://github.com/dgutov/robe/archive/0.7.8.tar.gz"
  sha256 "ed63fcff0cde46d91780f90577bca26d15d93b8905a5ce8c716a69289eca76f8"
  head "https://github.com/dgutov/robe.git"

  depends_on :emacs => "24.3"
  depends_on :ruby => "1.9"
  depends_on "homebrew/emacs/inf-ruby"

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"], "lib"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{Formula["inf-ruby"].opt_elisp}")
      (add-to-list 'load-path "#{elisp}")
      (load "robe")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

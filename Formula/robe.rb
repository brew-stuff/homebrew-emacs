require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Robe < EmacsFormula
  desc "Navigation, documentation lookup and completion for Ruby"
  homepage "https://github.com/dgutov/robe"
  url "https://github.com/dgutov/robe/archive/0.7.9.tar.gz"
  sha256 "f6b471dd4af841c3b79c14a0db57ba0a87209d8ca7d9845bbcfc82b20e9a79f4"
  head "https://github.com/dgutov/robe.git"

  depends_on :emacs => "24.3"
  depends_on :ruby => "1.9"
  depends_on "dunn/emacs/inf-ruby"

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

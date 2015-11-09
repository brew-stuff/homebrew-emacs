require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Logito < EmacsFormula
  desc "Tiny logging framework for Emacs"
  homepage "https://github.com/sigma/logito"
  url "https://github.com/sigma/logito/archive/v0.1.tar.gz"
  sha256 "c28a60f49ec9e2a9c3167e51d31ec799b68df81391282f3b0b52813d1450a428"
  head "https://github.com/sigma/logito.git"

  depends_on :emacs

  def install
    byte_compile "logito.el"
    elisp.install "logito.el", "logito.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "logito")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

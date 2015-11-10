require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Mocker < EmacsFormula
  desc "Simple mocking framework for Emacs"
  homepage "https://github.com/sigma/mocker.el"
  url "https://github.com/sigma/mocker.el/archive/v0.3.1.tar.gz"
  sha256 "7549aa6ce2021da2a0f664dc225cda0cac27a4cb4f867180004ac9ec17cae76f"
  head "https://github.com/sigma/mocker.el.git"

  depends_on :emacs
  depends_on "cask" => :build
  depends_on "homebrew/emacs/el-x"

  def install
    system "make", "test"
    byte_compile "mocker.el"
    elisp.install "mocker.el", "mocker.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "mocker")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

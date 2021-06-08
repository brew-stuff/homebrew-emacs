require File.expand_path("../Homebrew/emacs_formula", __dir__)

class ElMock < EmacsFormula
  desc "Tiny mock and stub framework in Emacs Lisp"
  homepage "https://github.com/rejeep/el-mock.el"
  url "https://github.com/rejeep/el-mock.el/archive/v1.25.1.tar.gz"
  sha256 "0b8db563fbf9d8a4793afa57c9f59eb44ca07f5de248fff61fb677542c49bc9b"
  head "https://github.com/rejeep/el-mock.el.git"

  depends_on EmacsRequirement

  def install
    byte_compile "el-mock.el"
    elisp.install "el-mock.el", "el-mock.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "el-mock")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

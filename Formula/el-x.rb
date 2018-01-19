require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ElX < EmacsFormula
  desc "Emacs Lisp extensions"
  homepage "https://github.com/sigma/el-x"
  url "https://github.com/sigma/el-x/archive/v0.3.1.tar.gz"
  sha256 "734e654b26ae699c41bb8f691fb4ec4d6064c156b02ddf3c2fa98b7dc16a527e"
  head "https://github.com/sigma/el-x.git"

  depends_on EmacsRequirement
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    system "make"
    elisp.install Dir["lisp/*"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "el-x")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

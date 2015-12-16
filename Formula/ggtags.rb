require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Ggtags < EmacsFormula
  desc "Emacs interface to GNU Global tagging system"
  homepage "https://github.com/leoliu/ggtags"
  url "https://github.com/leoliu/ggtags/archive/0.8.11.tar.gz"
  sha256 "5fd28f3f5d63d3325474b93f1a992f9f38bdb1279c3a2d3ba67b034d1728ecf4"
  head "https://github.com/leoliu/ggtags.git"

  depends_on :emacs => "24.1"
  depends_on "global" => "with-ctags"

  def install
    system "make"
    elisp.install "ggtags.el", "ggtags.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/ggtags")
      (load "ggtags")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

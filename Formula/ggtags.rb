require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Ggtags < EmacsFormula
  desc "Emacs interface to GNU Global tagging system"
  homepage "https://github.com/leoliu/ggtags"
  url "https://github.com/leoliu/ggtags/archive/0.8.10.tar.gz"
  sha256 "e43162c92426b7f5ea04f661cf32012c2430764050897af47c171410e7677a9f"
  head "https://github.com/leoliu/ggtags.git"

  depends_on :emacs => "24.1"
  depends_on "global" => "with-exuberant-ctags"

  def install
    system "make"
    (share/"emacs/site-lisp/ggtags").install "ggtags.el",
                                             "ggtags.elc"
    doc.install "README.rst"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'ggtags)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "ggtags")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Ggtags < EmacsFormula
  desc "Emacs interface to GNU Global tagging system"
  homepage "https://github.com/leoliu/ggtags"
  url "https://github.com/leoliu/ggtags/archive/0.8.12.tar.gz"
  sha256 "428638328fed1884bfb5b5ea1c57b141ac78415f4f40aa98bef3faff58388d26"
  head "https://github.com/leoliu/ggtags.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c6997c50b8f9e6bc6f4372673cd0ead4c45019563326078053235d748e879f1" => :sierra
    sha256 "0c6997c50b8f9e6bc6f4372673cd0ead4c45019563326078053235d748e879f1" => :el_capitan
    sha256 "0c6997c50b8f9e6bc6f4372673cd0ead4c45019563326078053235d748e879f1" => :yosemite
  end

  depends_on EmacsRequirement => "24.1"
  depends_on "global" => "with-ctags"

  def install
    system "make"
    elisp.install "ggtags.el", "ggtags.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/ggtags")
      (load "ggtags")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

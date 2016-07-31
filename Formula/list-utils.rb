require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ListUtils < EmacsFormula
  desc "List-manipulation utility functions for Emacs"
  homepage "https://github.com/rolandwalker/list-utils"
  url "https://github.com/rolandwalker/list-utils/archive/v0.4.4.tar.gz"
  sha256 "9758652f7a81d4cbf4126af401cf5a7d76fe286bbaddb7647b050ac410ec81f5"
  head "https://github.com/rolandwalker/list-utils.git"

  depends_on :emacs => "22.2"

  def install
    system "make", "test-batch", "RESOLVED_EMACS=#{which "emacs"}"
    system "make", "build", "RESOLVED_EMACS=#{which "emacs"}"
    elisp.install "list-utils.el", "list-utils.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "list-utils")
      (print (list-utils-depth '(1 2 (3 4 (5 6 7)))))
    EOS
    assert_equal "3", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

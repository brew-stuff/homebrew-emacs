require File.expand_path("../Homebrew/emacs_formula", __dir__)

class ClGeneric < EmacsFormula
  desc "Forward compatibility library for Emacs 24 and below"
  homepage "https://elpa.gnu.org/packages/cl-generic.html"
  url "https://elpa.gnu.org/packages/cl-generic-0.3.el"
  sha256 "f893845a425e414d5a5769670b958b36cb5c3ef1b63f0c8ccb565f09171a636d"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/cl-generic/cl-generic.el"

  depends_on EmacsRequirement

  def install
    mv "cl-generic-#{version}.el", "cl-generic.el"

    byte_compile "cl-generic.el"
    elisp.install "cl-generic.el", "cl-generic.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "cl-generic")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

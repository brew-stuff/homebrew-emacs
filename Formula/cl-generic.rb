require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ClGeneric < EmacsFormula
  desc "Forward compatibility library for Emacs 24 and below"
  homepage "http://elpa.gnu.org/packages/cl-generic.html"
  url "http://elpa.gnu.org/packages/cl-generic-0.2.el"
  sha256 "e3261768c03d5cbc43cc9f6fc05d4c155fb357db0eac09cba4cd91e048085e2c"
  head "http://git.savannah.gnu.org/cgit/emacs/elpa.git/plain/packages/cl-generic/cl-generic.el"

  depends_on :emacs

  def install
    mv "cl-generic-#{version}.el", "cl-generic.el"

    byte_compile "cl-generic.el"
    (share/"emacs/site-lisp/cl-generic").install "cl-generic.el",
                                                 "cl-generic.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "cl-generic")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

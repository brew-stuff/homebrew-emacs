require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ShutUp < EmacsFormula
  desc "Emacs package to reduce verbosity"
  homepage "https://github.com/cask/shut-up"
  url "https://github.com/cask/shut-up/archive/v0.3.2.tar.gz"
  sha256 "a11df31fe160d2ec7e94874e98dca804414f08e6cd9fe7e38ec994359bcc7f26"
  head "https://github.com/cask/shut-up.git"

  depends_on EmacsRequirement

  def install
    byte_compile "shut-up.el"
    elisp.install "shut-up.el", "shut-up.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "shut-up")
      (shut-up
        (print "Honk"))
    EOS
    assert_equal "", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

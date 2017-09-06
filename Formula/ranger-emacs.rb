require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class RangerEmacs < EmacsFormula
  desc "Alternate file navigation for Emacs"
  homepage "https://github.com/ralesi/ranger.el"
  url "https://github.com/ralesi/ranger.el/archive/v0.9.8.5.tar.gz"
  sha256 "70700d814c2e44f246182954d6c14db7889ae7486a155af0831b70d34eb48459"
  head "https://github.com/ralesi/ranger.el.git"

  bottle :disable

  depends_on :emacs => "24.4"

  def install
    system "make", "compile"
    elisp.install "ranger.el", "ranger.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "ranger")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

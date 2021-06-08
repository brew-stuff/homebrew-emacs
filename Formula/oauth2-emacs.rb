require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Oauth2Emacs < EmacsFormula
  desc "Emacs library for OAuth 2.0"
  homepage "https://elpa.gnu.org/packages/oauth2.html"
  url "https://elpa.gnu.org/packages/oauth2-0.11.el"
  sha256 "b76a4c5792292d3e3b5616e4f38735601e2f0ac5f59006dd5ecbeaaf6462b379"

  depends_on EmacsRequirement

  def install
    mv "oauth2-#{version}.el", "oauth2.el"
    byte_compile "oauth2.el"
    elisp.install "oauth2.el", "oauth2.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "oauth2")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

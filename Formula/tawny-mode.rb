require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TawnyMode < EmacsFormula
  desc "Ontology Editing with Tawny-OWL"
  homepage "https://github.com/phillord/tawny-owl"
  url "https://github.com/phillord/tawny-owl/archive/1.5.0.tar.gz"
  sha256 "e51b0973bdea2d1379b89b070055525f6d066a82665d783da322b4c4292e9baa"
  head "https://github.com/phillord/tawny-owl.git"

  bottle :disable

  depends_on EmacsRequirement => "25.1"
  depends_on "dunn/emacs/cider"
  depends_on "dunn/emacs/queue-emacs"

  def install
    byte_compile "emacs/tawny-mode.el"
    elisp.install "emacs/tawny-mode.el", "emacs/tawny-mode.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["cider"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["clojure-mode"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["queue-emacs"].opt_elisp}")
      (load "tawny-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Indium < EmacsFormula
  desc "JavaScript development environment for Emacs"
  homepage "https://github.com/NicolasPetton/Indium"
  url "https://github.com/NicolasPetton/Indium/archive/1.2.0.tar.gz"
  sha256 "ccde3ce17f2d39760a18a8346f0c51a4c9956e2a7bd27deb3c629178402fcd07"
  head "https://github.com/NicolasPetton/Indium.git"

  bottle :disable

  depends_on EmacsRequirement => "25.1"
  depends_on "dunn/emacs/company-mode"
  depends_on "dunn/emacs/js2-mode"
  depends_on "dunn/emacs/seq"
  depends_on "dunn/emacs/websocket-emacs"

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]

    cd "doc" do
      system "make", "info"
      info.install Dir["*.info"]
    end
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/company-mode"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/js2-mode"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/seq"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/websocket-emacs"].opt_elisp}")
      (load "indium")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

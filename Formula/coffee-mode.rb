require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CoffeeMode < EmacsFormula
  desc "Emacs major mode for CoffeeScript"
  homepage "https://github.com/defunkt/coffee-mode"
  url "https://github.com/defunkt/coffee-mode/archive/v0.6.0.tar.gz"
  sha256 "f1e2fd0797d69ece434b00a88bbfddb4265d5e9bf12fd2a7d39ccbfb00200870"
  head "https://github.com/defunkt/coffee-mode.git"

  depends_on :emacs => "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < 24.3

  def install
    system "make", "test"
    byte_compile "coffee-mode.el"
    (share/"emacs/site-lisp/coffee-mode").install "coffee-mode.el",
                                                  "coffee-mode.elc"
    doc.install "README.md", "examples"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'coffee-mode)
    (add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/coffee-mode")
      (load "coffee-mode")
      (print (coffee-version))
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CoffeeMode < EmacsFormula
  desc "Emacs major mode for CoffeeScript"
  homepage "https://github.com/defunkt/coffee-mode"
  url "https://github.com/defunkt/coffee-mode/archive/v0.6.3.tar.gz"
  sha256 "7aa8e5858f8aa1de77ca6d2bf829d1f0b7db656905108426e53d03d8db4104fc"
  head "https://github.com/defunkt/coffee-mode.git"

  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    ert_run_tests Dir["test/*.el"]
    byte_compile "coffee-mode.el"
    elisp.install "coffee-mode.el", "coffee-mode.elc"
    doc.install "examples"
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

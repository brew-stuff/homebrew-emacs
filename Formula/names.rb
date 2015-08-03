require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Names < EmacsFormula
  desc "Namespacing for Emacs Lisp"
  homepage "https://github.com/Malabarba/names"
  url "https://github.com/Malabarba/names/archive/20150723.0.tar.gz"
  sha256 "353c5840828b298e826c3ebac267bcd72fd18988fccc2f50840b4df9022d0691"
  head "https://github.com/Malabarba/names.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    # tests don't pass
    # `make build` compiles in strict mode and so fails
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/names").install Dir["*.el"], Dir["*.elc"]
    doc.install Dir["*.org"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/names")
      (load "names")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

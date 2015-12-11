require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CoffeeMode < EmacsFormula
  desc "Emacs major mode for CoffeeScript"
  homepage "https://github.com/defunkt/coffee-mode"
  url "https://github.com/defunkt/coffee-mode/archive/v0.6.2.tar.gz"
  sha256 "caedf2077e89a7ea3d3984f7a15df6b193a0fe939678fd55d6e2fc7f101046f6"
  head "https://github.com/defunkt/coffee-mode.git"

  depends_on :emacs => "24.1"
  depends_on "cask"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    system "make", "test"
    byte_compile "coffee-mode.el"
    (share/"emacs/site-lisp/coffee-mode").install "coffee-mode.el",
                                                  "coffee-mode.elc"
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

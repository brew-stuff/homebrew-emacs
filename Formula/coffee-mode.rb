require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CoffeeMode < EmacsFormula
  desc "Emacs major mode for CoffeeScript"
  homepage "https://github.com/defunkt/coffee-mode"
  url "https://github.com/defunkt/coffee-mode/archive/v0.6.1.tar.gz"
  sha256 "5d3674e1cecf1c6566db496bbde97e34ebcf07b75e7ed7b07b569bc4412265dd"
  head "https://github.com/defunkt/coffee-mode.git"

  depends_on :emacs => "24.1"
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

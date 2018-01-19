require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Js2Mode < EmacsFormula
  desc "Improved major mode for editing JavaScript in Emacs"
  homepage "https://github.com/mooz/js2-mode"
  url "https://github.com/mooz/js2-mode/archive/20170721.tar.gz"
  sha256 "dcf8548ea1cd1c5ba2bc3a1a8764cbca3ba6d8fee7f1cedd5ec1ba0e1156f737"
  head "https://github.com/mooz/js2-mode.git"

  bottle :disable

  depends_on EmacsRequirement => "24.1"

  def install
    system "make", "all"
    system "make", "test"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "js2-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

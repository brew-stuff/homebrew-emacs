require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class RubyTools < EmacsFormula
  desc "Additional functions for ruby-mode"
  homepage "https://github.com/rejeep/ruby-tools.el"
  url "https://github.com/rejeep/ruby-tools.el/archive/v0.1.2.tar.gz"
  sha256 "1795cb04585defd4cae1df4d77c9b95b4aa73104b3388089a1096d4453e2ad33"
  head "https://github.com/rejeep/ruby-tools.el.git"

  depends_on :emacs

  def install
    byte_compile "ruby-tools.el"
    elisp.install "ruby-tools.el", "ruby-tools.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "ruby-tools")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

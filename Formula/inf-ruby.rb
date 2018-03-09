require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class InfRuby < EmacsFormula
  desc "Emacs REPL buffer connected to a Ruby subprocess"
  homepage "https://github.com/nonsequitur/inf-ruby"
  url "https://github.com/nonsequitur/inf-ruby/archive/2.5.1.tar.gz"
  sha256 "c60012110eb98605ef5d1c2d4ce8d11eca158eb34de71728ee932562e610e354"
  head "https://github.com/nonsequitur/inf-ruby.git"

  bottle :disable

  depends_on EmacsRequirement => "23.1"

  def install
    byte_compile "inf-ruby.el"
    elisp.install "inf-ruby.el", "inf-ruby.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "inf-ruby")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

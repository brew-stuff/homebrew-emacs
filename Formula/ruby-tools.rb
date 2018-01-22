require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class RubyTools < EmacsFormula
  desc "Additional functions for ruby-mode"
  homepage "https://github.com/rejeep/ruby-tools.el"
  url "https://github.com/rejeep/ruby-tools.el/archive/v0.1.2.tar.gz"
  sha256 "1795cb04585defd4cae1df4d77c9b95b4aa73104b3388089a1096d4453e2ad33"
  head "https://github.com/rejeep/ruby-tools.el.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6577103e65784a5e3dc9e7d7de98eb03ea172bd17c4c6341d33feda5830357f1" => :el_capitan
    sha256 "2e4aac3b6ba9c4ee87947be0b592f687c5287428f311ce76b3ee9651c9cb6f41" => :yosemite
    sha256 "2e4aac3b6ba9c4ee87947be0b592f687c5287428f311ce76b3ee9651c9cb6f41" => :mavericks
  end

  depends_on EmacsRequirement

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

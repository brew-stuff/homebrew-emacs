require File.expand_path("../Homebrew/emacs_formula", __dir__)

class PhpMode < EmacsFormula
  desc "Major mode for editing PHP files"
  homepage "https://github.com/ejmr/php-mode"
  url "https://github.com/ejmr/php-mode/archive/v1.19.0.tar.gz"
  sha256 "ba3c469eaee72fe25c0549249c859c2535cc0067857379e2713eb1416bed92a0"
  head "https://github.com/ejmr/php-mode.git"

  bottle :disable

  depends_on EmacsRequirement => "24.1"

  def install
    system "make", "test"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (require 'php-mode)
      (print php-mode-version-number)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

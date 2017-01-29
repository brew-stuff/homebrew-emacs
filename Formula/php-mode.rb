require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PhpMode < EmacsFormula
  desc "Major mode for editing PHP files"
  homepage "https://github.com/ejmr/php-mode"
  url "https://github.com/ejmr/php-mode/archive/v1.18.0.tar.gz"
  sha256 "3ab66c6d8b84e601700c49b42850145b797fb31a5a49d273a4048d394d519c01"
  head "https://github.com/ejmr/php-mode.git"

  depends_on :emacs => "24.1"

  def install
    system "make", "test"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (require 'php-mode)
      (print php-mode-version-number)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

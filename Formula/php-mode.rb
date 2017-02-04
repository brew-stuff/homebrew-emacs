require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PhpMode < EmacsFormula
  desc "Major mode for editing PHP files"
  homepage "https://github.com/ejmr/php-mode"
  url "https://github.com/ejmr/php-mode/archive/v1.18.2.tar.gz"
  sha256 "16b26a5584139db2dbc05414a686f54173d7505d7aa041ca12238188c23ea90c"
  head "https://github.com/ejmr/php-mode.git"

  bottle :disable

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
